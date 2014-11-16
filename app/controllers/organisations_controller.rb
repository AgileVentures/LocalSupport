class OrganisationsController < ApplicationController
  layout 'two_columns'
  # GET /organisations/search
  # GET /organisations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]

  def search
    @query_term = params[:q]
    @category_id = params.try(:[],'category').try(:[],'id')
    @category = Category.find_by_id(@category_id)
    @organisations = Organisation.order_by_most_recent
    @organisations = @organisations.search_by_keyword(@query_term).filter_by_category(@category_id)
    flash.now[:alert] = SEARCH_NOT_FOUND if @organisations.empty?
    @markers = build_markers(@organisations)
    @category_options = Category.html_drop_down_options
    render :template =>'organisations/index'
  end

  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Organisation.order_by_most_recent
    @markers = build_markers(@organisations)
    @category_options = Category.html_drop_down_options
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    @organisation = Organisation.find(params[:id])
    @pending_admin = current_user.pending_admin? @organisation if current_user
    @editable = current_user.can_edit?(@organisation) if current_user
    @deletable = current_user.can_delete?(@organisation) if current_user
    @can_create_volunteer_op = current_user.can_create_volunteer_ops?(@organisation) if current_user
    @grabbable = current_user ? current_user.can_request_org_admin?(@organisation) : true
   # @next_path = current_user ? organisation_user_path(@organisation.id, current_user.id) : new_user_session_path
    @markers = build_markers(@organisation)
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
    @categories_start_with = Category.first_category_name_in_each_type
  end

  # GET /organisations/1/edit
  def edit
    @organisation = Organisation.find(params[:id])
    @markers = build_markers(@organisation)
    @categories_start_with = Category.first_category_name_in_each_type
    return false unless user_can_edit? @organisation
    #respond_to do |format|
    #  format.html {render :layout => 'full_width'}
    #end
  end

  # POST /organisations
  # POST /organisations.json
  def create
    # model filters for logged in users, but we check here if that user is an admin
    # TODO refactor that to model responsibility?
     org_params = OrganisationParams.build params
     unless current_user.try(:admin?)
       flash[:notice] = PERMISSION_DENIED
       redirect_to organisations_path and return false
     end
    @organisation = Organisation.new(org_params)

    if @organisation.save
      redirect_to @organisation, notice: 'Organisation was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.json
  def update
    @organisation = Organisation.find(params[:id])
    params[:organisation][:admin_email_to_add] = params[:organisation_admin_email_to_add] if params[:organisation]
    update_params = OrganisationParams.build params 
    return false unless user_can_edit? @organisation
    if @organisation.update_attributes_with_admin(update_params)
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      flash[:error] = @organisation.errors[:administrator_email][0]
      render action: "edit"
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    unless current_user.try(:admin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    @organisation = Organisation.find(params[:id])
    @organisation.destroy
    flash[:success] = "Deleted #{@organisation.name}"

    redirect_to organisations_path
  end

class OrganisationParams 
    def self.build params
      params.require(:organisation).permit( :admin_email_to_add, :description, :address, :publish_address, :postcode, :email, 
                     :publish_email, :website, :publish_phone, :donation_info, :name, :telephone,
                     category_organisations_attributes: [:_destroy, :category_id, :id])
    end
  end

  private

  def build_markers(*organisations)
    Gmaps4rails.build_markers(organisations) do |org, marker|
      marker.lat org.latitude
      marker.lng org.longitude
      marker.infowindow render_to_string(
        partial: 'popup', locals: { org: org }
      )
    end.select do |marker|
      marker[:lat].present? && marker[:lng].present?
    end.to_json
  end

  def user_can_edit?(org)
    unless current_user.try(:can_edit?,org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    true
  end
end
