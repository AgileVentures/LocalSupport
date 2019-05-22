class VolunteerOpsController < ApplicationController
  layout 'two_columns_with_map', except: :embedded_map
  before_action :set_organisation, only: [:new, :create]
  before_action :authorize, except: [:search, :show, :index, :embedded_map]
  prepend_before_action :set_volunteer_op, only: [:show, :edit]
  before_action :add_breadcrumbs

  def search
    @query = params[:q]
    @volunteer_ops = VolunteerOp.order_by_most_recent.search_for_text(@query)
    flash.now[:alert] = SEARCH_NOT_FOUND if @volunteer_ops.empty?
    @markers = BuildMarkersWithInfoWindow
                   .with(VolunteerOp.build_by_coordinates(@volunteer_ops), self)
    render template: 'volunteer_ops/index'
  end

  def index
    @volunteer_ops = displayed_volunteer_ops unless iframe?
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
    response.headers.delete 'X-Frame-Options' if iframe?
    render :embedded_map, layout: false if iframe?
  end

  def show
    render template: 'pages/404', status: 404 and return if @volunteer_op.nil?
    @organisation = Organisation.friendly.find(@volunteer_op.organisation_id)
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def new
    @volunteer_op = VolunteerOpForm.new
    @can_publish_to_doit = true if current_user.superadmin?
  end

  def create
    params[:volunteer_op][:organisation_id] = @organisation.id
    @volunteer_op = VolunteerOpForm.new(volunteer_op_params)
    result = rendering(@volunteer_op, t('volunteer.create_success'), 'new')
    UpdateSocialMedia.new.post @volunteer_op if result and not Rails.env.development?
  end

  def edit
    volunteer_op_record = VolunteerOp.find(params[:id])
    @can_publish_to_doit = true if can_post_to_doit?(volunteer_op_record.id)
    @volunteer_op = VolunteerOpForm.new
    @volunteer_op.volunteer_op = volunteer_op_record
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def update
    volunteer_op_record = VolunteerOp.find(params[:id])
    @volunteer_op = VolunteerOpForm.new
    @volunteer_op.volunteer_op = volunteer_op_record
    @organisation = @volunteer_op.organisation
    @volunteer_op.assign_attributes(volunteer_op_params)
    rendering(@volunteer_op, t('volunteer.update_success'), 'edit')
  end

  def destroy
    @volunteer_op = VolunteerOp.find(params[:id])
    @volunteer_op.destroy
    flash[:success] = "Deleted #{@volunteer_op.title}"
    redirect_to volunteer_ops_path
  end



  def volunteer_op_params
    args = [:description, :title, :organisation_id, :address, :postcode,
            :post_to_doit, :advertise_start_date, :advertise_end_date,
            :doit_org_id, :role_description, :skills_needed,
            :when_volunteer_needed, :contact_details]
    params.require(:volunteer_op).permit(*args)
  end

  private

  def add_breadcrumbs
    if @organisation.present?
      add_breadcrumb 'All Organisations', organisations_path
      add_breadcrumb @organisation.name, organisation_path(@organisation)
    end

    add_breadcrumb 'Volunteers', (root_path unless action_name == 'index')
    super 'Volunteer Opportunity', (@volunteer_op.title if @volunteer_op.present?),
          (volunteer_op_path(@volunteer_op) if @volunteer_op.present?)
  end

  def displayed_volunteer_ops
    vol_ops = VolunteerOp.order_by_most_recent.send(restrict_by_feature_scope)
    VolunteerOp.add_coordinates(vol_ops)
  end

  def restrict_by_feature_scope
    if Feature.active?(:doit_volunteer_opportunities) &&
       Feature.active?(:reachskills_volunteer_opportunities)
      return :all
    end
    return :doit if Feature.active?(:doit_volunteer_opportunities)
    return :reachskills if Feature.active?(:reachskills_volunteer_opportunities)
    :local_only
  end

  def authorize
    return if org_owner?
    flash[:error] = t('authorize.org_owner_or_superadmin')
    redirect_to '/' and return
  end

  def org_owner?
    current_user.present? && (current_user.can_edit? org_independent_of_route)
  end

  def org_independent_of_route
    organisation_set_for_nested_route? || organisation_for_simple_route
  end

  def organisation_set_for_nested_route?
    @organisation
  end

  def organisation_for_simple_route
    VolunteerOp.find(params[:id]).organisation
  end

  def organisation_for_nested_route
    Organisation.friendly.find(params[:organisation_id])
  end

  def set_organisation
    @organisation = organisation_for_nested_route
  end

  def set_volunteer_op
    @volunteer_op = VolunteerOp.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @volunteer_op = nil
  end

  def meta_tag_title
    return super unless @volunteer_op
    @volunteer_op.title
  end

  def meta_tag_description
    return super unless @volunteer_op
    @volunteer_op.description
  end

  def can_post_to_doit?(vol_op_id)
    current_user.superadmin? && !DoitTrace.published?(vol_op_id)

  end
end
