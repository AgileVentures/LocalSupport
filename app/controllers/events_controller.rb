class EventsController < BaseOrganisationsController
  layout 'two_columns_with_map'
  before_action :logged_in_user, only: [:new, :create, :index, :show]
  #before_action :superadmin?, except:[:show, :index]

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
    @events = Event.upcoming(10)
    #@markers = build_map_markers(@events.organisations)

    #respond_to do |format|
    #  format.html {  @events = Event.upcoming(10) }
    #  format.json {  @events = Event.where(start_date: params[:start]..params[:end]) }
    #end
  end

  private

  def event_success
    'Event was successfully created'
  end

  def event_params
    params.require(:event).permit(:title, :description, :postal, :start_date, :end_date, :organisations)
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
