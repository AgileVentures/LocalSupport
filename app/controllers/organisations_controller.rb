class OrganisationsController < BaseOrganisationsController
  layout 'two_columns_with_map'
  # GET /organisations/search
  # GET /organisations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]

  def search
    @parsed_params = SearchParamsParser.new(params)
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
    @organisations = Queries::Organisations.search_by_keyword_and_category(
      @parsed_params
    )
    flash.now[:alert] = SEARCH_NOT_FOUND if @organisations.empty?
    @markers = build_map_markers(@organisations)

    render :template =>'organisations/index'
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
    organisations = Organisation.where(id: params[:id])
    @organisation = organisations.first!
    @pending_org_admin = current_user.pending_org_admin? @organisation if current_user
    @editable = current_user.can_edit?(@organisation) if current_user
    @deletable = current_user.can_delete?(@organisation) if current_user
    @can_create_volunteer_op = current_user.can_create_volunteer_ops?(@organisation) if current_user
    @grabbable = current_user ? current_user.can_request_org_admin?(@organisation) : true
    @can_propose_edits = current_user.present? && !@editable
    @markers = build_map_markers(organisations)
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
    @categories_start_with = Category.first_category_name_in_each_type
  end

  # GET /organisations/1/edit
  def edit
    organisations = Organisation.where(id: params[:id])
    @organisation = organisations.first!
    @markers = build_map_markers(organisations)
    @categories_start_with = Category.first_category_name_in_each_type
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
     org_params = OrganisationParams.build params
     unless current_user.try(:superadmin?)
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
    params[:organisation][:superadmin_email_to_add] = params[:organisation_superadmin_email_to_add] if params[:organisation]
    update_params = OrganisationParams.build params 
    return false unless user_can_edit? @organisation
    if @organisation.update_attributes_with_superadmin(update_params)
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      @categories_start_with = Category.first_category_name_in_each_type
      flash[:error] = @organisation.errors[:superadministrator_email][0]
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
    @organisation = Organisation.find(params[:id])
    @organisation.destroy
    flash[:success] = "Deleted #{@organisation.name}"

    redirect_to organisations_path
  end

  class OrganisationParams
    def self.build params
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
        category_organisations_attributes: [:_destroy, :category_id, :id]
      )
    end
  end

  private

  def user_can_edit?(org)
    unless current_user.try(:can_edit?,org)
      flash[:notice] = PERMISSION_DENIED
      redirect_to organisation_path(params[:id]) and return false
    end
    true
  end

end
