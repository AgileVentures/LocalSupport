class SessionsController < Devise::SessionsController

  def create
    session[:pending_organisation_id] = params[:pending_organisation_id]
    super
  end
end
