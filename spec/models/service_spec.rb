

RSpec.describe Service, type: :model do
  subject(:service) { described_class.new(address: '1 Tree Rd', postcode: 'HA1 3HJ')}

  it { should belong_to :organisation }

  it { should have_many(:self_care_categories).through(:self_care_category_services) }
  
  it 'has full address' do
    expect(service.full_address).to eq '1 Tree Rd, HA1 3HJ'
  end

  let(:organisation) { create(:organisation)}

  # never going to create this way?
  xit 'can be imported from another model' do
    service = Service.from_model(organisation)
    expect(service.name).to eq(organisation.name)
  end

  let(:json_file) {'test/fixtures/kcsc_self_care_single.json'}
  let(:contact) { JSON.parse(File.read(json_file)) }

  it 'can be imported from another model with categories' do
    service = Service.from_model(organisation, contact)
    category_names = service.self_care_categories.map(&:name)
    expect(category_names).to contain_exactly('Brain Injury', 'Carers')
  end

  xit 'can be built by coordinates' do
    services = Service.build_by_coordinates
  end
end


