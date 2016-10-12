class VolunteerOpsController < ApplicationController
  layout 'two_columns_with_map'
  before_action :authorize, except: [:search, :show, :index]
  before_action :set_organisation, only: [:new, :create]
  before_action :set_volunteer_op, only: [:show, :edit]

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
    @organisation = Organisation.friendly.find(@volunteer_op.organisation_id)
    organisations = Organisation.where(id: @organisation.id)
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = @organisation.id
    @volunteer_op = VolunteerOp.new(volunteer_op_params)
    result = @volunteer_op.save
    result ? vol_op_redirect('Volunteer op was successfully created.') : render(:new)
  end

  def edit
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = BuildMarkersWithInfoWindow.with(VolunteerOp.build_by_coordinates, self)
  end

  def update
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    notice = 'Volunteer Opportunity was successfully updated.'
    result = @volunteer_op.update_attributes(volunteer_op_params)
    result ? vol_op_redirect(notice) : render(action: 'edit')
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
    VolunteerOp.order_by_most_recent.send(restrict_by_feature_scope)
  end

  def restrict_by_feature_scope
    return :all if Feature.active?(:doit_volunteer_opportunities)
    :local_only
  end

  def authorize
    # set @organisation
    # then can make condition:
    # unless current_user.can_edit? organisation
    unless org_owner? || superadmin?
      flash[:error] = 'You must be signed in as an organisation owner or ' \
                      'site superadmin to perform this action!'
      (redirect_to '/') && return
    end
  end

  def org_owner?
    if params[:organisation_id].present? && current_user_has_organisation?
      current_user.organisation.friendly_id == params[:organisation_id]
    elsif current_user_has_organisation?
      current_user.organisation == VolunteerOp.find(params[:id]).organisation
    end
  end

  def current_user_has_organisation?
    current_user.present? && current_user.organisation.present?
  end

  def set_organisation
    @organisation = Organisation.friendly.find(params[:organisation_id])
  end

  def set_volunteer_op
    @volunteer_op = VolunteerOp.find(params[:id])
  end

  def vol_op_redirect(notice)
    redirect_to(@volunteer_op, notice: notice)
  end
end
