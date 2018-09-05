class EventsController < ApplicationController
  add_breadcrumb 'Events', :events_path
  layout 'two_columns_with_map'
  before_action :logged_in_user, only: [:new, :create, :edit, :update]
  before_action :superadmin?, except:[:show, :index, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update]
  def index
    query = params['q']
    @events = query.blank? ? Event.upcoming(10) : Event.search(query)
    flash.now[:alert] = SEARCH_NOT_FOUND if @events.empty? and query
    @markers = BuildMarkersWithInfoWindow
                   .with(Event.build_by_coordinates(@events), self)

    respond_to :html, :json
  end

  def new
    @event = Event.new
    add_breadcrumb 'New Event'
  end

  def create
    @event = Event.new(event_params)
    @event.organisation = current_user.organisation if @current_user.organisation_id?
    @event.save ? redirect_to(@event, notice: event_success) : render(:new)
  end

  def show
    add_breadcrumb @event.title
    @markers = BuildMarkersWithInfoWindow
                   .with(Event.build_by_coordinates([@event]), self)
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: 'Event has been succesfully updated'
    else
      flash[:warning] = 'Your event was not updated successfully'
      render :edit
    end
  end

  private

  def event_success
    'Event was successfully created'
  end

  def event_params
    params.require(:event).permit(:title, :description,
      :start_date, :end_date, :organisation_id, :address)
  end

  def logged_in_user
    redirect_to new_user_session_path unless signed_in?
  end

  def superadmin?
    return if current_user.try(:superadmin?)
    flash[:notice] = PERMISSION_DENIED
    redirect_to events_path and return false
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
