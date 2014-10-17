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
    @json = gmap4rails_with_popup_partial(@organisations,'popup')
    @category_options = Category.html_drop_down_options
    render :template =>'organisations/index'
  end

  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Organisation.order_by_most_recent
    @json = gmap4rails_with_popup_partial(@organisations,'popup')
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
    @json = gmap4rails_with_popup_partial(@organisation,'popup')
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
  end

  # GET /organisations/1/edit
  def edit
    @organisation = Organisation.find(params[:id])
    @json = gmap4rails_with_popup_partial(@organisation,'popup')
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
     unless current_user.try(:admin?)
       flash[:notice] = PERMISSION_DENIED
       redirect_to organisations_path and return false
     end
    @organisation = Organisation.new(params[:organisation])

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
    return false unless user_can_edit? @organisation
    if @organisation.update_attributes_with_admin(params[:organisation])
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

  private
  def gmap4rails_with_popup_partial(item, partial)
    item.to_gmaps4rails  do |org, marker|
      marker.infowindow render_to_string(:partial => partial, :locals => { :@org => org})
    end
  end
  def user_can_edit?(org)
    unless current_user.try(:can_edit?,org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    true
  end
end
