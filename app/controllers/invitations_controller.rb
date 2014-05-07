class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only, tested in a request spec
  def create
    @response = build_response(params)

    respond_to do |format|
      format.json { render :json => @response.to_json }
    end
  end

  private

  def build_response(params)
    debugger
    invitation = Inviter.new(User, Devise, params[:resend_invitation])

    params[:values].each_with_object({}) do |value, dict|

      dict[value[:id]] = invitation.rsvp(
          value[:email],
          current_user,
          value[:id]

      )

    end
  end

end
