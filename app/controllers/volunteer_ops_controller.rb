class VolunteerOpsController < ApplicationController
  layout 'two_columns'
  before_filter :authorize, :except => [:show, :index]

  def index
    @volunteer_ops = VolunteerOp.order_by_most_recent
    @organisations = @volunteer_ops.map { |op| op.organisation }
    @markers = build_map_markers(@organisations)
  end

  def show
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = build_map_markers([@organisation])
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = params[:organisation_id]
    volops_params = VolunteerOpsController::VolunteerOpParams.build params     
    @volunteer_op = VolunteerOp.new(volops_params)
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    @markers = build_map_markers([@organisation])
  end

  def update
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    vol_op_params = VolunteerOpParams.build params 
    if @volunteer_op.update_attributes(vol_op_params)
      redirect_to @volunteer_op, notice: 'Volunteer Opportunity was successfully updated.'
    else
      render action: "edit"
    end
  end
  class VolunteerOpParams
    def self.build params
      params.require(:volunteer_op).permit(:description, :title, :organisation_id)
    end
  end
  private

  def build_marker_for_vol_op(org, marker)
    marker.lat org.latitude
    marker.lng org.longitude
    marker.picture(
      { :url => ActionController::Base.helpers.asset_path("volunteer_icon.png"),
        :width   => 32,
        :height  => 32 }
    )
    marker.title   "Click here to see volunteer opportunities at #{org.name}"
    marker.infowindow render_to_string(
      partial: 'popup', locals: { org: org }
    )
  end

  def authorize
    # set @organisation
    # then can make condition:
    # unless current_user.can_edit? organisation
    unless org_owner? or admin?
      flash[:error] = 'You must be signed in as an organisation owner or site admin to perform this action!'
      redirect_to '/'
      false
    end
  end

  def org_owner?
    if params[:organisation_id].present? && current_user.present? && current_user.organisation.present?
      return current_user.organisation.id.to_s == params[:organisation_id]
    else
       current_user.organisation == VolunteerOp.find(params[:id]).organisation if current_user.present? && current_user.organisation.present?
    end

  end

  def build_map_markers(organisations)
    Gmaps4rails.build_markers(organisations) do |org, marker|
      build_marker_for_vol_op(org, marker)
    end.select do |marker|
      marker[:lat].present? && marker[:lng].present?
    end.to_json
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
