class SessionsController < Devise::SessionsController

  def create
    debugger
    session[:pending_organisation_id] = params[:pending_organisation_id]
    super
  end
end
