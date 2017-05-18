class VolunteerOpsController < ApplicationController
  add_breadcrumb 'Volunteers', :root_url
  layout 'two_columns_with_map'
  before_action :set_organisation, only: [:new, :create]
  before_action :authorize, except: [:search, :show, :index]
  prepend_before_action :set_volunteer_op, only: [:show, :edit]

  def search
    @query = params[:q]
    @volunteer_ops = VolunteerOp.order_by_most_recent.search_for_text(@query)
    flash.now[:alert] = SEARCH_NOT_FOUND if @volunteer_ops.empty?
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
    render template: 'volunteer_ops/index'
  end

  def index
    @volunteer_ops = displayed_volunteer_ops
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def show
    render template: 'pages/404', status: 404 and return if @volunteer_op.nil?
    @organisation = Organisation.friendly.find(@volunteer_op.organisation_id)
    organisations = Organisation.where(id: @organisation.id)
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
    add_breadcrumb @organisation.name, organisation_path(@organisation)
    add_breadcrumb @volunteer_op.title, :volunteer_op_path
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = @organisation.id
    @volunteer_op = VolunteerOp.new(volunteer_op_params)
    result = @volunteer_op.save
    result ? vol_op_redirect(t('volunteer.create_success')) : render(:new)
  end

  def edit
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def update
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    result = @volunteer_op.update_attributes(volunteer_op_params)
    result ? vol_op_redirect(t('volunteer.update_success')) : render(action: 'edit')
  end

  def destroy
    @volunteer_op = VolunteerOp.find(params[:id])
    @volunteer_op.destroy
    flash[:success] = "Deleted #{@volunteer_op.title}"
    redirect_to volunteer_ops_path
  end

  def volunteer_op_params
    args = [:description, :title, :organisation_id, :address, :postcode]
    params.require(:volunteer_op).permit(*args)
  end

  private

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

  def vol_op_redirect(notice)
    redirect_to(@volunteer_op, notice: notice)
  end

  def meta_tag_title
    return super unless @volunteer_op
    @volunteer_op.title
  end

  def meta_tag_description
    return super unless @volunteer_op
    @volunteer_op.description
  end
end
