class OrganisationsController < BaseOrganisationsController
  layout 'two_columns_with_map'
  # GET /organisations/search
  # GET /organisations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]
  prepend_before_action :set_organisation, only: [:show, :update, :edit]
  before_action :assign_cat_name_ids, only: [:search, :index, :show]
  after_action :assign_markers, only: [:search, :index, :edit]

  def search
    @parsed_params = SearchParamsParser.new(params)
    @organisations = Queries::Organisations.search_by_keyword_and_category(
      @parsed_params
    )
    flash.now[:alert] = SEARCH_NOT_FOUND if @organisations.empty?
    render :template =>'organisations/index'
  end

  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Queries::Organisations.order_by_most_recent
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    @user_opts = {}
    render template: 'pages/404', status: 404 and return if @organisation.nil?
    organisations = Organisation.where(id: @organisation.id)

    if current_user
      @user_opts = get_user_capabilities_hash(@organisation)
    else 
      @user_opts = { grabbable: true }
    end

    @user_opts[:can_propose_edits] = current_user.present? && !@user_opts[:editable]
    @user_opts[:markers] = build_map_markers(organisations)
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
  end

  # GET /organisations/1/edit
  def edit
    @organisations = Organisation.where(id: @organisation.id)
    return false unless user_can_edit? @organisation
    #respond_to do |format|
    #  format.html {render :layout => 'full_width'}
    #end
  end

  # POST /organisations
  # POST /organisations.json
  def create
    # model filters for logged in users, but we check here if that user is an superadmin
    # TODO refactor that to model responsibility?
    unless current_user.try(:superadmin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisations_path and return false
    end
    @organisation = Organisation.new(organisation_params)
    if @organisation.save
      redirect_to @organisation, notice: 'Organisation was successfully created.'
    else
     render :new
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.json
  def update
    params[:organisation][:superadmin_email_to_add] = params[:organisation_superadmin_email_to_add] if params[:organisation]
    return false unless user_can_edit? @organisation
    if @organisation.update_attributes_with_superadmin(organisation_params)
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    unless current_user.try(:superadmin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    @organisation = Organisation.friendly.find(params[:id])
    @organisation.destroy
    flash[:success] = "Deleted #{@organisation.name}"

    redirect_to organisations_path
  end

  private

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

  def assign_markers
    @markers = build_map_markers(@organisations)
  end

  def assign_cat_name_ids
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
  end

  def get_user_capabilities_hash(organisation)
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

  def user_can_edit?(org)
    unless current_user.try(:can_edit?,org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    true
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
