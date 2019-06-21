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
    services_with_coords = Service.build_by_coordinates(@services)
    @markers = BuildMarkersWithInfoWindow.with(services_with_coords, self)
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
    params.require(:service).permit(:organisation_id,
                                    :description,
                                    :contact_id, 
                                    :name, 
                                    :service_activities, 
                                    :postcode,
                                    :telephone, 
                                    :email, 
                                    :website,
                                    :where_we_work, 
                                    :city, 
                                    :latitude, 
                                    :longitude, 
                                    :address, 
                                    :activity_type,  
                                    :beneficiaries)
  end
end
