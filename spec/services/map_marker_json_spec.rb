require 'rails_helper'

describe MapMarkerJson do
  let(:organisation) { create(:organisation) }
  let(:organisations) { Organisation.where(id: organisation) }

  it do
    expect {|b| Gmaps4rails.build_markers(organisations, &b) }.to yield_control
  end

  it 'yields the organisation and a marker' do
    _subject do |o,m|
      expect(o).to eq organisation
      expect(m).to be_an_instance_of Gmaps4rails::MarkersBuilder::MarkerBuilder
    end
  end

  it 'discards markers without a lat and lng' do
    expect(_subject {}).to eq []
  end

  it 'keeps markers with a lat and lng' do
    expect(_subject { |_,m| m.lat(0) ; m.lng(0) }).to eq [{"lat"=>0, "lng"=>0}]
  end

  def _subject
    JSON.parse(described_class.build(organisations) {|o,m| yield o,m })
  end
end
