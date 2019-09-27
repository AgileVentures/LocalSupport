class ServicesController < BaseOrganisationsController
  add_breadcrumb 'Services', :services_path
  layout 'two_columns_with_map'
  before_action :authorize, except: [:search, :show, :index, :embedded_map]
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @query = params[:q]
    @categories = params[:self_care_category_id]
    @activity_type = params[:activity_type]
    @where_we_work = params[:where_we_work]
    @pcn_overlay = params[:pcn_overlay]
    @services = Service.order_by_most_recent
    @services = @services.search_for_text(@query) if @query.present?
    @services = @services.filter_by_categories(@categories) if category_filter?
    @services = @services.where(activity_type: @activity_type) if activity_type?
    @services = @services.where(where_we_work: @where_we_work) if @where_we_work
    services_with_coords = Service.build_by_coordinates(@services)
    @markers = BuildMarkersWithInfoWindow.with(services_with_coords, self)
    response.headers.delete 'X-Frame-Options'
    render :embedded_map, layout: false if iframe?
  end

  # GET /services/1
  # GET /services/1.json
  def show
    # ideally we'd center the map on the indiviudal service
    @markers = BuildMarkersWithInfoWindow.with(Service.build_by_coordinates([@service]), self)
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

  def category_filter?
    @categories.present? and not @categories.include? ''
  end

  def activity_type?
    @activity_type.present? and not @activity_type.include? ''
  end

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
