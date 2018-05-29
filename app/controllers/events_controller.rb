class EventsController < ApplicationController
  add_breadcrumb 'Events', :events_path
  layout 'two_columns_with_map'
  before_action :logged_in_user, only: [:new, :create]
  before_action :superadmin?, except:[:show, :index]

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
    check_user_organisation
    @event = Event.new(event_params)
    @event.save ? redirect_to(@event, notice: event_success) : render(:new)
  end

  def show
    @event = Event.find_by_id(params[:id])
    add_breadcrumb @event.title
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

  def check_user_organisation
    params[:event][:organisation_id] = current_user.organisation if current_user.organisation.present?
  end
end
