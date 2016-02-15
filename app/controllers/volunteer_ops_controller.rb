class VolunteerOpsController < ApplicationController
  layout 'two_columns_with_map'
  before_filter :authorize, :except => [:show, :index]

  def index
    @volunteer_ops = VolunteerOp.order_by_most_recent
    @organisations = Organisation.where(id: @volunteer_ops.select(:organisation_id))
    @markers = build_map_markers(@organisations)
  end

  def show
    @volunteer_op = VolunteerOp.find(params[:id])
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = build_map_markers(organisations)
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = params[:organisation_id]
    @volunteer_op = VolunteerOp.new(volunteer_op_params)
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @volunteer_op = VolunteerOp.find(params[:id])
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = build_map_markers(organisations)
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

  def volunteer_op_params
    params.require(:volunteer_op).permit(
      :description,
      :title,
      :organisation_id,
    )
  end

  private

  def build_map_markers(organisations)
    VolunteerOpMarkerBuilder.new(
      organisations,
      self,
      MapMarkerJson,
      ActionController::Base.helpers,
    ).perform
  end

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
      current_user.organisation.id.to_s == params[:organisation_id]
    else
      current_user.organisation == VolunteerOp.find(params[:id]).organisation if current_user.present? && current_user.organisation.present?
    end
  end
end
