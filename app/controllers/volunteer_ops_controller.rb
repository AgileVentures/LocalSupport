class VolunteerOpsController < ApplicationController
  layout 'two_columns_with_map'
  before_filter :authorize, :except => [:show, :index]

  def index
    @volunteer_ops = VolunteerOp.order_by_most_recent
    @organisations = Organisation.where(id: @volunteer_ops.select(:organisation_id))
    @markers, @doit_orgs = assemble_volunteer_markers(@organisations)
  end

  def show
    @volunteer_op = VolunteerOp.find(params[:id])
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @editable = current_user.can_edit?(@organisation) if current_user
    @markers = build_map_markers(organisations)
  end

  def new
    @volunteer_op = VolunteerOp.new
  end

  def create
    params[:volunteer_op][:organisation_id] = params[:organisation_id]
    @volunteer_op = VolunteerOp.new(volunteer_op_params)
    if @volunteer_op.save
      redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @volunteer_op = VolunteerOp.find(params[:id])
    organisations = Organisation.where(id: @volunteer_op.organisation_id)
    @organisation = organisations.first!
    @markers = build_map_markers(organisations)
  end

  def update
    @volunteer_op = VolunteerOp.find(params[:id])
    @organisation = @volunteer_op.organisation
    if @volunteer_op.update_attributes(volunteer_op_params)
      redirect_to @volunteer_op, notice: 'Volunteer Opportunity was successfully updated.'
    else
      render action: "edit"
    end
  end

  def volunteer_op_params
    params.require(:volunteer_op).permit(
      :description,
      :title,
      :organisation_id,
    )
  end

  private

  def assemble_volunteer_markers(organisations)
    harrow_markers = build_map_markers(organisations)
    doit_markers = '[]'
    if Feature.active? :doit_volunteer_opportunities
      doit_orgs = collect_all_items
      doit_markers = build_map_markers(doit_orgs, :doit, false)
    end
    markers = list_of_markers(harrow_markers, doit_markers)
    [markers, doit_orgs]
  end

  def list_of_markers(harrow_markers, doit_markers)
    return doit_markers if harrow_markers == '[]' 
    return harrow_markers if doit_markers == '[]' 
    harrow_markers[0...-1]+', ' + doit_markers[1..-1]
  end

  def build_map_markers(organisations, type = :harrow, include_extra_organisation_data = true)
    ::MapMarkerJson.build(organisations, include_extra_organisation_data) do |org, marker|
      marker.lat org.latitude
      marker.lng org.longitude
      marker.infowindow render_to_string(partial: "popup_#{type}", locals: { org: org })
      marker.json(
        custom_marker: render_to_string(
          partial: 'shared/custom_marker',
          locals: { attrs: [ActionController::Base.helpers.asset_path("volunteer_icon_#{type}.png"),
                    'data-id' => org.id,
                    class: 'vol_op', title: "Click here to see volunteer opportunities at #{org.name}"]}
        ),
        index: 1,
        type: 'vol_op'
      )
    end
  end

  # This needs to be a helper method for the do-it API
  def collect_all_items
    host = 'https://api.do-it.org'
    href = "/v1/opportunities\?lat\=51.5978\&lng\=-0.3370\&miles\=0.5 "
    doit_orgs = []
    id = 1
    while href
      url = host + href
      response = HTTParty.get(url)
      if response.body && response.body != '[]'
        resp_items = JSON.parse(response.body)['data']['items']
        resp_items.each do |item|
          org = OpenStruct.new(latitude: item['lat'], longitude: item['lng'], 
                name: item['title'], id: id, description: item['description'], 
                opportunity_id: item['id'], 
                org_name: item['for_recruiter']['name'], 
                org_link: item['for_recruiter']['slug'])
          doit_orgs.push (org)
          id += 1
        end
        next_page = JSON.parse(response.body)['links']['next']
      end
      href = next_page ? next_page['href'] : nil
    end
    doit_orgs
  end

  def authorize
    # set @organisation
    # then can make condition:
    # unless current_user.can_edit? organisation
    unless org_owner? or superadmin?
      flash[:error] = 'You must be signed in as an organisation owner or site superadmin to perform this action!'
      redirect_to '/' and return
    end
  end

  def org_owner?
    if params[:organisation_id].present? && current_user.present? && current_user.organisation.present?
      current_user.organisation.id.to_s == params[:organisation_id]
    else
      current_user.organisation == VolunteerOp.find(params[:id]).organisation if current_user.present? && current_user.organisation.present?
    end
  end
end
