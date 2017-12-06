class InvitationsController < ApplicationController
  before_action :authorize

  # xhr only, tested in a request spec
  def create
    render json: ::BatchInviteJob.new(
      params, current_user
    ).run.to_json
  end
end
