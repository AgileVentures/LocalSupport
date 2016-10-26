class InvitationsController < ApplicationController

  # xhr only, tested in a request spec
  def create
    authorize :invitation, :create?
    render json: ::BatchInviteJob.new(
      params, current_user
    ).run.to_json
  end
end
