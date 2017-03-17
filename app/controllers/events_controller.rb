class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  def new
    @event = Event.new
  end

  def create
    unless current_user.try(:superadmin?)
      flash[:notice] = PERMISSION_DENIED
      redirect_to events_path and return false
    end
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created'
    else
      render :new
    end
  end

  def show

  end

  def index

  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date)
  end

  def logged_in_user
    redirect_to new_user_session_path unless signed_in?
  end
end
