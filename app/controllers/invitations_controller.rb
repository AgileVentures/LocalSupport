class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    render :json => ::Invitations.(
      params,
      current_user,
    ).to_json
  end

end
