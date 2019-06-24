require 'rails_helper'

RSpec.describe Service, type: :model do
  subject(:service) { described_class.new(address: '1 Tree Rd', postcode: 'HA1 3HJ')}

  it { should belong_to :organisation }
  
  it 'has full address' do
    expect(service.full_address).to eq '1 Tree Rd, HA1 3HJ'
  end

  let(:organisation) { create(:organisation)}
  it 'can be imported from another model' do
    service = Service.from_model(organisation)
    expect(service.name).to eq(organisation.name)
  end

  xit 'can be built by coordinates' do
    services = Service.build_by_coordinates()
  end
end


