require './app/services/build_markers_with_info_window'
#require 'json'

describe BuildMarkersWithInfoWindow do
  let(:listener) { double :listener }
  let(:helper) { double :helper }
  let(:volops) { double :volops }
  let(:marker_builder) { double :marker_builder }
  let(:markers) {double :markers, to_json: :json}

  subject(:build_markers_with_info_window) do
    described_class.with(volops, listener, marker_builder, helper)
  end

  it 'returns json version of markers' do
    allow(marker_builder).to receive(:generate).with(volops, any_args).and_return(markers)

    expect(build_markers_with_info_window).to eq :json
    expect(marker_builder).to have_received(:generate)
  end

end
