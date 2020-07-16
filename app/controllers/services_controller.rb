class ServicesController < BaseOrganisationsController
  add_breadcrumb 'Services', :services_path
  layout :choose_layout
  before_action :authorize, except: [:search, :show, :index, :embedded_map]
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    index_instance_vars_from_params
    index_services_and_markers
    response.headers.delete 'X-Frame-Options'
    render_embedded_view 
  end

  # GET /services/1
  # GET /services/1.json
  def show
    # ideally we'd center the map on the indiviudal service
    services = Service.build_by_coordinates([@service])
    @markers = BuildMarkersWithInfoWindow.with(services, self)
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

  def index_instance_vars_from_params
    @query = params[:q]
    @categories = params[:self_care_category_id]
    @activity_type = params[:activity_type]
    @where_we_work = params[:where_we_work]
    @pcn_overlay = params[:pcn_overlay]
  end

  def index_services_and_markers
    @services = Service.order_by_most_recent
    @services = @services.search_for_text(@query) if @query.present?
    @services = @services.filter_by_categories(@categories) if category_filter?
    @services = @services.where(activity_type: @activity_type) if activity_type?
    @services = @services.where(where_we_work: @where_we_work) if @where_we_work
    services_with_coords = Service.build_by_coordinates(@services)
    @markers = BuildMarkersWithInfoWindow.with(services_with_coords, self)
  end

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

  def render_embedded_view
    if iframe_all?
      render :embedded_index
    elsif iframe_map?
      render :embedded_map
    end
  end
end
