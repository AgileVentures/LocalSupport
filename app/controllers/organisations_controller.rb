class OrganisationsController < BaseOrganisationsController
  add_breadcrumb 'All Organisations', :organisations_path
  layout 'two_columns_with_map'
  before_action :authenticate_user!, except: [:search, :index, :show]
  prepend_before_action :set_organisation, only: [:show, :update, :edit]

  # GET /organisations/search
  # GET /organisations/search.json
  def search
    @parsed_params = SearchParamsParser.new(params)
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
    @organisations = Queries::Organisations
                         .search_by_keyword_and_category(@parsed_params)
    flash.now[:alert] = SEARCH_NOT_FOUND if @organisations.empty?
    @markers = build_map_markers(@organisations)
    render template: 'organisations/index'
  end

  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Queries::Organisations.order_by_most_recent
    @markers = build_map_markers(@organisations)
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    render template: 'pages/404', status: 404 and return if @organisation.nil?
    organisations = Organisation.where(id: @organisation.id)
    @user_opts = current_user ? get_user_options(@organisation) : { grabbable: true }
    @user_opts[:can_propose_edits] = current_user.present? && !@user_opts[:editable]
    @markers = build_map_markers(organisations)
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
  end

  # GET /organisations/1/edit
  def edit
    path = organisation_path(params[:id])
    organisations = Organisation.where(id: @organisation.id)
    @markers = build_map_markers(organisations)
    check_privileges(:can_edit?, path, @organisation); return if performed?
  end

  # POST /organisations
  # POST /organisations.json
  def create
    check_privileges(:superadmin?, organisations_path); return if performed?
    @organisation = Organisation.new(organisation_params)
    @organisation.check_geocode
    rendering('Organisation was successfully created.', 'new')
  end

  # PUT /organisations/1
  # PUT /organisations/1.json
  def update
    setup_super_admin_email if params[:organisation]
    path = organisation_path(params[:id])
    check_privileges(:can_edit?, path, @organisation); return if performed?
    @organisation.update_attributes_with_superadmin(organisation_params)
    @organisation.check_geocode
    rendering('Organisation was successfully updated.', 'edit')
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    check_privileges(:superadmin?, organisation_path(params[:id])); return if performed?
    @organisation = Organisation.friendly.find(params[:id])
    @organisation.destroy
    flash[:success] = "Deleted #{@organisation.name}"
    redirect_to organisations_path
  end

  private

  def setup_super_admin_email
    params[:organisation][:superadmin_email_to_add] = params[:organisation_superadmin_email_to_add]
  end

  def organisation_params
    params.require(:organisation).permit(
      :superadmin_email_to_add,
      :description,
      :address,
      :publish_address,
      :postcode,
      :email,
      :publish_email,
      :website,
      :publish_phone,
      :donation_info,
      :name,
      :telephone,
      category_ids: []
    )
  end

  def check_privileges(method, path, org=nil)
    unless current_user.try(method, org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to path and return
    end
  end

  def rendering(notice, action)
    if @organisation.save
      redirect_to @organisation, notice: notice
    else
      render action: action
    end
  end

  def get_user_options(organisation)
      {
        pending_org_admin: current_user.pending_org_admin?(organisation),
        editable: current_user.can_edit?(organisation),
        deletable: current_user.can_delete?(organisation),
        can_create_volunteer_op: current_user.can_create_volunteer_ops?(organisation),
        grabbable: current_user.can_request_org_admin?(organisation)
      }
  end

  def set_organisation
    @organisation = Organisation.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @organisation = nil
  end

  def meta_tag_title
    return super unless @organisation
    @organisation.name
  end

  def meta_tag_description
    return super unless @organisation
    @organisation.description
  end
end
