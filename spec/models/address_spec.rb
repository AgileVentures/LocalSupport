require_relative '../../app/models/address'

describe Address, "#parse" do 
  let(:address) { Address.new(address_to_parse) }
  subject { address.parse }

  context 'must be able to extract postcode and address' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA'
    end

    it { should eql(:address => 'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => 'HA1 1BA') }
  end

  context 'must be able to handle postcode extraction when no postcode' do
    let(:address_to_parse) do 
      'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW'
    end
    it { should eql(:address =>'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => '') }
  end

  context 'must be able to handle postcode extraction when nil address' do
    let(:address_to_parse) { nil } 

    it { should eql(:address =>'', :postcode => '') }
  end

end

#TODO Refactor Organization class to pull logic into Address class?
describe Organization do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @org1 = FactoryGirl.build(:organization, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org1.save!
    @org2 = FactoryGirl.build(:organization, :name => 'Indian Elders Associaton', :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :latitude => 77, :longitude => 77, :donation_info => 'www.indian-elders.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org2.save!
    @org3 = FactoryGirl.build(:organization, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org3.save!
  end

  #TODO: refactor with expect{} instead of should as Rspec 2 promotes
  it 'should delete geocoding errors and save organization' do
    new_address = '777 pinner road'
    @org1.latitude = 77
    @org1.longitude = 77
    Gmaps4rails.should_receive(:geocode).and_raise(Gmaps4rails::GeocodeStatus)
    @org1.address = new_address
    @org1.update_attributes :address => new_address
    @org1.errors['gmaps4rails_address'].should be_empty
    actual_address = Organization.find_by_name(@org1.name).address
    actual_address.should eq new_address
    @org1.latitude.should eq nil
    @org1.longitude.should eq nil
  end

  describe 'not_geocoded?' do
    it 'should return true if it lacks latitude and longitude' do
      @org1.not_geocoded?.should be_true
    end

    it 'should return false if it has latitude and longitude' do
      @org2.not_geocoded?.should be_false
    end
  end

  describe 'run_geocode?' do
    it 'should return true if address is changed' do
      @org1.address = "asjkdhas,ba,asda"
      @org1.run_geocode?.should be_true
    end

    it 'should return false if address is not changed' do
      @org1.should_receive(:address_changed?).and_return(false)
      @org1.should_receive(:not_geocoded?).and_return(false)
      @org1.run_geocode?.should be_false
    end

    it 'should return false if org has no address' do
      org = Organization.new
      org.run_geocode?.should be_false
    end

    it 'should return true if org has an address but no coordinates' do
      @org1.should_receive(:not_geocoded?).and_return(true)
      @org1.run_geocode?.should be_true
    end

    it 'should return false if org has an address and coordinates' do
      @org2.should_receive(:not_geocoded?).and_return(false)
      @org2.run_geocode?.should be_false
    end
  end

  describe "acts_as_gmappable's behavior is curtailed by the { :process_geocoding => :run_geocode? } option" do
    it 'no geocoding allowed when saving if the org already has an address and coordinates' do
      Gmaps4rails.should_not_receive(:geocode)
      @org2.email = 'something@example.com'
      @org2.save!
    end

    # it will try to rerun incomplete geocodes, but not valid ones, so no harm is done
    it 'geocoding allowed when saving if the org has an address BUT NO coordinates' do
      Gmaps4rails.should_receive(:geocode)
      @org2.longitude = nil ; @org2.latitude = nil
      @org2.email = 'something@example.com'
      @org2.save!
    end

    it 'geocoding allowed when saving if the org address changed' do
      Gmaps4rails.should_receive(:geocode)
      @org2.address = '777 pinner road'
      @org2.save!
    end
  end
end