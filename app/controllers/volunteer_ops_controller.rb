class VolunteerOpsController < ApplicationController
  before_filter :authorize, :except => [:index, :show]

  # GET /volunteer_ops
  def index
    @volunteer_ops = VolunteerOp.all
  end

  # GET /volunteer_ops/1
  def show
    @volunteer_op = VolunteerOp.find(params[:id])
  end

  # GET /volunteer_ops/new
  def new
    @volunteer_op = VolunteerOp.new
  end

  # POST /volunteer_ops
  def create
    params[:volunteer_op][:organization_id] = current_user.organization.id
    @volunteer_op = VolunteerOp.new(params[:volunteer_op])
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  def authorize
    unless org_owner?
      flash[:error] = 'You must be signed in as an organization owner to perform this action!'
      redirect_to '/'
      false
    end
  end

  # lame, but this is the best we can do without nested routes
  def org_owner?
    current_user.organization.present? if current_user.present?
  end
end
