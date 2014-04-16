class OrganizationsController < ApplicationController
  layout 'two_columns'
  # GET /organizations/search
  # GET /organizations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]

  def search
    @query_term = params[:q]
    @category_id = params.try(:[], 'category').try(:[], 'id')
    @category = Category.find_by_id(@category_id)
    @organizations = Organization.order_by_most_recent
    @organizations = @organizations.search_by_keyword(@query_term).filter_by_category(@category_id)
    flash.now[:alert] = SEARCH_NOT_FOUND if @organizations.empty?
    @category_options = Category.html_drop_down_options
    render :template => 'organizations/index'
  end

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.order_by_most_recent
    @category_options = Category.html_drop_down_options
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @editable = current_user.can_edit?(@organization) if current_user
    @grabbable = current_user ? current_user.can_request_org_admin?(@organization) : true
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
    return false unless user_can_edit? @organization
  end

  # POST /organizations
  # POST /organizations.json
  def create
    # model filters for logged in users, but we check here if that user is an admin
    # TODO refactor that to model responsibility?
    unless current_user.try(:admin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organizations_path and return false
    end
    @organization = Organization.new(params[:organization])

    if @organization.save
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])
    params[:organization][:admin_email_to_add] = params[:organization_admin_email_to_add] if params[:organization]
    return false unless user_can_edit? @organization
    if @organization.update_attributes_with_admin(params[:organization])
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    unless current_user.try(:admin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organization_path(params[:id]) and return false
    end
    @organization = Organization.find(params[:id])
    @organization.destroy

    redirect_to organizations_url
  end

  private
  def user_can_edit?(org)
    unless current_user.try(:can_edit?, org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organization_path(params[:id]) and return false
    end
    true
  end
end
