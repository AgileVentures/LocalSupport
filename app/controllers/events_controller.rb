class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  def new
  end

private
  def logged_in_user
    unless signed_in?
      flash[:danger] = "Please log in."
      redirect_to new_user_session_path
    end
  end
end
