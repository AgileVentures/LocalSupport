require './app/services/build_markers_with_info_window'
#require 'json'

describe BuildMarkersWithInfoWindow do
  let(:listener) { double :listener }
  let(:helper) { double :helper }
  let(:volop1) { spy :volop }
  let(:volops) { double :volops }
  let(:marker_builder) { double :marker_builder }
  let(:markers) {double :markers, to_json: :json}

  subject(:build_markers_with_info_window) do
    described_class.with(volops, listener, marker_builder, helper)
  end

  before do
    allow(marker_builder).to receive(:build_markers).with(volops).and_yield(volop1, (spy :marker)).and_return(markers)
    allow(listener).to receive(:render_to_string).exactly(2).times
    allow(helper).to receive(:asset_path)
  end

  it 'returns json version of markers' do
    expect(marker_builder).to receive(:build_markers).with(volops).and_yield(volop1, (spy :marker)).and_return(markers)
    expect(build_markers_with_info_window).to eq :json
  end

  it 'requests marker builder to build markers' do
    expect(marker_builder).to receive(:build_markers).with(volops).and_yield(volop1, (spy :marker)).and_return(markers)
    build_markers_with_info_window
  end

  it 'calls render_to_string on listener' do
    expect(listener).to receive(:render_to_string).exactly(2).times
    build_markers_with_info_window
  end

  it 'calls asset_path on helper' do
    expect(helper).to receive(:asset_path)
    build_markers_with_info_window
  end

end