class BuildMarkersWithInfoWindow

  def self.with(models, listener, marker_builder = Gmaps::MarkersBuilder, helper = ActionController::Base.helpers)
    new(models, listener, marker_builder, helper).send(:run)
  end

  private

  attr_reader :models, :listener, :marker_builder, :helper

  def initialize(models, listener, marker_builder, helper)
    @models = models
    @listener = listener
    @marker_builder = marker_builder
    @helper = helper
  end

  def run
    marker_builder.generate(models, &method(:build_single_marker)).to_json
  end

  def build_single_marker(model, marker)
    location = model.first
    models = model.last
    if model.first.try(:source)
      source = VolunteerOp.get_source(models)
    else
      source = 'local'
    end
    marker.lat location.latitude
    marker.lng location.longitude
    marker.infowindow listener.render_to_string(
      partial: "shared/popup/#{source}.html.erb", locals: {vol_ops: models}
    )
    marker.json(
      custom_marker: listener.render_to_string(
        partial: 'shared/custom_marker.html.erb',
        locals: {attrs: [helper.asset_path("volunteer_icon_#{source}.png"),
                         class: 'vol_op',
                         title: 'Click here to see volunteer opportunities']}
      ),
      index: 1,
      type: 'vol_op'
    )
  end

end
