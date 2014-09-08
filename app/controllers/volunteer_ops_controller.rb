class VolunteerOpsController < ApplicationController
  layout 'two_columns'
  before_filter :authorize, :except => [:show, :index]
  
  def index
    @volunteer_ops = VolunteerOp.all
    @organisations = @volunteer_ops.map { |op| op.organisation }
    @json = gmap4rails_with_popup_partial(@organisations, 'popup')
  end
  
  def show
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    @json = gmap4rails_with_popup_partial(@organisation, 'popup')
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = current_user.organisation.id
    @volunteer_op = VolunteerOp.new(params[:volunteer_op])
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  def authorize
    unless org_owner?
      flash[:error] = 'You must be signed in as an organisation owner to perform this action!'
      redirect_to '/'
      false
    end
  end

  def org_owner?
    current_user.organisation.present? if current_user.present?
  end

  def gmap4rails_with_popup_partial(item, partial)
    item.to_gmaps4rails  do |org, marker|
      marker.picture({
                       :picture => ActionController::Base.helpers.asset_path("volunteer_icon.png"),
                       :width   => 32,
                       :height  => 32
                     })
      marker.title   "Click here to see volunteer opportunities at #{org.name}"
      marker.infowindow render_to_string(:partial => partial, :locals => { :@org => org})
    end
  end
end
