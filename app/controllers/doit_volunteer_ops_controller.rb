class DoitVolunteerOpsController < ApplicationController
  layout 'full_width'
  before_action :authorize
  
  def new
    @doit_vol_op = DoitVolunteerOp.new
    @volunteer_op = VolunteerOp.find(params[:volunteer_op_id])
  end

  def create
    @volunteer_op = VolunteerOp.find(params[:volunteer_op_id])
    @doit_vol_op = DoitVolunteerOp.new(doit_vol_op_params)
    @doit_vol_op.volunteer_op = @volunteer_op
    if @doit_vol_op.save(trace_handler: DoitTrace)
      flash[:notice] = 'Volunteer opportunity was published successfully to Doit'
      redirect_to volunteer_op_path(@volunteer_op)
    else
      render :new
    end
  end

  private

  def doit_vol_op_params
    params.require(:doit_volunteer_op).permit(:advertise_start_date, :advertise_end_date, :doit_org_id, :vol_op)
  end

end
