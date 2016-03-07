require './app/services/build_markers_with_info_window'
#require 'json'

describe BuildMarkersWithInfoWindow do
  let(:listener){spy :listener}
  let(:volopone){double :volop}
  let(:voloptwo){double :volop}
  let(:volops){[volopone,voloptwo]}
  let(:marker_builder){spy :marker_builder}

  subject(:build_markers_with_info_window) do
    described_class.with(volops,listener, marker_builder)
  end

  it 'requests marker builder to build markers' do
    build_markers_with_info_window
    expect(marker_builder).to have_received(:build_markers).with(volops)
  end
  
end