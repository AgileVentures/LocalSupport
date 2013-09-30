require 'spec_helper'

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

  it 'should not try to geocode when saving if the org already has an address, longitude and latitude' do
    Gmaps4rails.should_not_receive(:geocode)
    @org2.email = 'something@example.com'
    @org2.save!
  end

  it 'should try to geocode when saving if the org has a new address' do
    Gmaps4rails.should_receive(:geocode)
    @org2.address = '777 pinner road'
    @org2.save!
  end

end