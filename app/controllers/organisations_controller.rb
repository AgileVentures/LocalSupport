class OrganisationsController < BaseOrganisationsController
  layout 'two_columns_with_map'
  # GET /organisations/search
  # GET /organisations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]
  before_action :set_organisation, only: [:show, :update, :edit]
  before_action :set_tags, only: [:show]

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
    organisations = Organisation.where(id: @organisation.id)
    @pending_org_admin = current_user.pending_org_admin? @organisation if current_user
    @markers = build_map_markers(organisations)
    @cat_name_ids = Category.name_and_id_for_what_who_and_how
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
    authorize @organisation
  end

  # GET /organisations/1/edit
  def edit
    authorize @organisation
    organisations = Organisation.where(id: @organisation.id)
    @markers = build_map_markers(organisations)
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

    @organisation = Organisation.new(org_params)
    authorize @organisation
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
    update_params = OrganisationParams.build params
    authorize @organisation
    if @organisation.update_attributes_with_superadmin(update_params)
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    @organisation = Organisation.friendly.find(params[:id])
    authorize @organisation
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
        category_ids: []
      )
    end
  end

  private

  def set_organisation
    @organisation = Organisation.friendly.find(params[:id])
  end

  def set_tags
    set_meta_tags title: @organisation.name,
                  site: 'Harrow Community Network | Harrow volunteering',
                  reverse: true,
                  description: @organisation.description,
                  author: 'http://www.agileventures.org',
                  og: {
                      title: @organisation.name,
                      site: 'Harrow Community Network',
                      reverse: true,
                      description: @organisation.description,
                      author: 'http://www.agileventures.org'
                  }
  end
end
