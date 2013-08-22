class OrganizationsController < ApplicationController
  # GET /organizations/search
  # GET /organizations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]
  def search
    # should this be a model method with a model spec around it ...?

    @query_term = params[:q]
    @category_id = params["category"]["id"] if !params["category"].nil? && !params["category"]["id"].blank?
    @category = Category.find_by_id(@category_id) unless @category_id.blank?

    @organizations = Organization.search_by_keyword(@query_term).filter_by_category(@category_id)
    # TODO work out where is a good place to store these strings
    flash.now[:alert] = "Sorry, it seems we don't have quite what you are looking for." if @organizations.empty?
    @json = gmap4rails_with_popup_partial(@organizations,'popup')
    # TODO would it make sense to move the following to the view
    # to avoid cluttering the controller?
    @category_options = Category.html_drop_down_options
    respond_to do |format|
      format.html { render :template =>'organizations/index'}
      format.json { render json:  @organizations }
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.order("updated_at DESC")
    @json = gmap4rails_with_popup_partial(@organizations,'popup')
    @category_options = Category.html_drop_down_options
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @editable = current_user.can_edit?(@organization) if current_user
    @json = gmap4rails_with_popup_partial(@organization,'popup')
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    #TODO Eliminate code duplication for permissions across methods
    @organization = Organization.find(params[:id])
    unless current_user.try(:can_edit?,@organization)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
  end

  # POST /organizations
  # POST /organizations.json
  def create
    # model filters for logged in users, but we check here if that user is an admin
    # TODO refactor that to model responsibility?
     unless current_user.try(:admin?)
       flash[:notice] = "You don't have permission"
       redirect_to organizations_path and return false
     end
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])
    params[:organization][:admin_email_to_add] = params[:organization_admin_email_to_add] if params[:organization]
    unless current_user.try(:can_edit?,@organization)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    respond_to do |format|
      if @organization.update_attributes_with_admin(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    unless current_user.try(:admin?)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :ok }
    end
  end

  private
  def gmap4rails_with_popup_partial(item, partial)
    item.to_gmaps4rails  do |org, marker|
      marker.infowindow render_to_string(:partial => partial, :locals => { :@org => org})
    end
  end
end
