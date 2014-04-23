class VolunteerOpsController < ApplicationController
  # GET /volunteer_ops
  def index
    @volunteer_ops = VolunteerOp.all
  end
end
