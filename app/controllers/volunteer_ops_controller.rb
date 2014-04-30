class VolunteerOpsController < ApplicationController
  layout 'two_columns'
  before_filter :authorize, :except => [:show, :index]
  
  def index
    @volunteer_ops = VolunteerOp.all
  end
  
  def show
    @volunteer_op = VolunteerOp.find(params[:id])
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

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

  def org_owner?
    #TODO this is the best we can do without nested routes
    current_user.organization.present? if current_user.present?
  end
end
