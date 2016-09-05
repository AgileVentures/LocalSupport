class BuildMarkersWithInfoWindow

  def self.with(volops, listener, marker_builder = Gmaps4rails, helper = ActionController::Base.helpers)
    new(volops, listener, marker_builder, helper).send(:run)
  end

  private

  attr_reader :volops, :listener, :marker_builder, :helper

  def initialize(volops, listener, marker_builder, helper)
    @volops = volops
    @listener = listener
    @marker_builder = marker_builder
    @helper = helper
  end

  def run
    method(:build_single_marker)
    marker_builder.build_markers(volops, &method(:build_single_marker)).to_json
  end

  def build_single_marker(volop, marker)
    location = volop.first
    vol_ops = volop.last
    source = VolunteerOp.get_source(vol_ops)
    marker.lat location.latitude
    marker.lng location.longitude
    marker.infowindow listener.render_to_string(
      partial: "volunteer_ops/popup/#{source}", locals: {vol_ops: vol_ops}
    )
    marker.json(
      custom_marker: listener.render_to_string(
        partial: 'shared/custom_marker',
        locals: {attrs: [helper.asset_path("volunteer_icon_#{source}.png"),
                         # 'data-id' => volop.id,
                         class: 'vol_op',
                         title: 'Click here to see volunteer opportunities']}
      ),
      index: 1,
      type: 'vol_op'
    )
  end

end
