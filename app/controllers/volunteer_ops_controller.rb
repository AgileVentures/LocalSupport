class VolunteerOpsController < ApplicationController
  # GET /volunteer_ops
  # GET /volunteer_ops.json
  def index
    @volunteer_ops = VolunteerOp.all
  end
end
