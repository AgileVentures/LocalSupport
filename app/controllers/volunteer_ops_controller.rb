class VolunteerOpsController < ApplicationController
  layout 'two_columns_with_map'
  before_action :authorize, :except => [:search, :show, :index]

  def search
    @query = params[:q]
    @volunteer_ops = VolunteerOp.order_by_most_recent.search_for_text(@query)
    flash.now[:alert] = SEARCH_NOT_FOUND if @volunteer_ops.empty?
    @markers = BuildMarkersWithInfoWindow.with(@volunteer_ops,self)
    render template: 'volunteer_ops/index'
  end

  def index
    @volunteer_ops = VolunteerOp.order_by_most_recent
    @volunteer_ops = Feature.active?(:doit_volunteer_opportunities) ? @volunteer_ops : @volunteer_ops.local_only
    @markers = BuildMarkersWithInfoWindow.with(@volunteer_ops,self)
  end

  def show
    @volunteer_ops = VolunteerOp.where(id: params[:id])
    @volunteer_op = @volunteer_ops.first
    @organisation = Organisation.friendly.find(@volunteer_op.organisation_id)
    organisations = Organisation.where(id: @organisation.id)
    @editable = current_user.can_edit?(@organisation) if current_user

    @markers = BuildMarkersWithInfoWindow.with(@volunteer_ops,self)
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    org = Organisation.friendly.find(params[:organisation_id])
    params[:volunteer_op][:organisation_id] = org.id
    @volunteer_op = VolunteerOp.new(volunteer_op_params)
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @volunteer_ops = VolunteerOp.where(id: params[:id])
    @volunteer_op = @volunteer_ops.first
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = BuildMarkersWithInfoWindow.with(@volunteer_ops,self)
  end

  def update
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    if @volunteer_op.update_attributes(volunteer_op_params)
      redirect_to @volunteer_op, notice: 'Volunteer Opportunity was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @volunteer_op = VolunteerOp.find(params[:id])
    @volunteer_op.destroy
    flash[:success] = "Deleted #{@volunteer_op.title}"

    redirect_to volunteer_ops_path
  end

  def volunteer_op_params
    params.require(:volunteer_op).permit(
      :description,
      :title,
      :organisation_id,
    )
  end

  private

  def authorize
    # set @organisation
    # then can make condition:
    # unless current_user.can_edit? organisation
    unless org_owner? or superadmin?
      flash[:error] = 'You must be signed in as an organisation owner or site superadmin to perform this action!'
      redirect_to '/' and return
    end
  end

  def org_owner?
    if params[:organisation_id].present? && current_user.present? && current_user.organisation.present?
      current_user.organisation.friendly_id == params[:organisation_id]
    else
      current_user.organisation == VolunteerOp.find(params[:id]).organisation if current_user.present? && current_user.organisation.present?
    end
  end
end
