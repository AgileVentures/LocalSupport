class ServicesController < BaseOrganisationsController
  add_breadcrumb 'Services', :services_path
  layout 'two_columns_with_map'
  before_action :authorize, except: [:search, :show, :index, :embedded_map]
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @query = params[:q]
    @services = Service.order_by_most_recent
    @services = @services.search_for_text(@query) if @query.present?
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end
   
  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.' 
    else
      render :edit 
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    redirect_to services_url, notice: 'Service was successfully destroyed.' 
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # we'll reduce this but let's get clean first
  def service_params # rubocop:disable Metrics/MethodLength
    params.require(:service).permit(:contact_id, 
                                    :display_name, 
                                    :service_activities, 
                                    :postal_code,
                                    :office_main_phone_general_phone, 
                                    :office_main_email, 
                                    :website, 
                                    :delivered_by_organization_name, 
                                    :where_we_work,
                                    :self_care_one_to_one_or_group, 
                                    :self_care_service_category, 
                                    :self_care_category_secondary, 
                                    :self_care_service_agreed, 
                                    :location_type, 
                                    :street_address, 
                                    :street_number, 
                                    :street_name, 
                                    :street_unit, 
                                    :supplemental_address_1, 
                                    :supplemental_address_2,
                                    :supplemental_address_3, 
                                    :city, 
                                    :latitude, 
                                    :longitude, 
                                    :address_name, 
                                    :county, 
                                    :state, 
                                    :country, 
                                    :groups, 
                                    :tags, 
                                    :activity_type, 
                                    :summary_of_activities, 
                                    :beneficiaries)
  end
end
