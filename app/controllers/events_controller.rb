class EventsController < ApplicationController
  layout 'two_columns_with_map'
  before_action :logged_in_user, only: [:new, :create]
  before_action :superadmin?, except:[:show, :index]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.save ? redirect_to(@event, notice: event_success) : render(:new)
  end

  def show
    @event = Event.find_by_id(params[:id])
  end

  def index
    respond_to do |format|
      format.html do   
        @events = Event.upcoming(10)
        @markers = BuildMarkersWithInfoWindow
          .with(Event.build_by_coordinates(@events), self) 
      end
      format.json do
        @events = Event.where(start_date: params[:start]..params[:end]) 
        @markers = BuildMarkersWithInfoWindow
          .with(Event.build_by_coordinates(@events), self)
      end
    end
  end

  private

  def event_success
    'Event was successfully created'
  end

  def event_params
    params.require(:event).permit(:title, :description, :postal, 
      :start_date, :end_date, :organisation_id)
  end

  def logged_in_user
    redirect_to new_user_session_path unless signed_in?
  end

  def superadmin?
    return if current_user.try(:superadmin?)
    flash[:notice] = PERMISSION_DENIED
    redirect_to events_path and return false
  end
end
