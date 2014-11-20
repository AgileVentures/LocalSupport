require 'spec_helper'

describe MapMarkerJson do
  let(:organisation) { double(:organisation) }

  it 'passes the organisation into the block' do
    expect(organisation).to receive(:honk_honk)
    _subject { |o,_| o.honk_honk }
  end

  it 'discards markers without a lat and lng' do
    expect(_subject {}).to eq []
  end

  it 'keeps markers with a lat and lng' do
    expect(_subject { |_,m| m.lat(0) ; m.lng(0) }).to eq [{"lat"=>0, "lng"=>0}]
  end

  def _subject
    JSON.parse(described_class.build([organisation]) {|o,m| yield o,m })
  end
end
