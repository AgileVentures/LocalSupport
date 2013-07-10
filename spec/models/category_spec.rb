require 'spec_helper'

describe 'Category' do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
    @category1 = FactoryGirl.build(:category)
    @category1.save!
    @category2 = FactoryGirl.build(:category)
    @category2.save!
    @org1 = FactoryGirl.build(:organization, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org1.save!
    @org2 = FactoryGirl.build(:organization, :name => 'Indian Elders Associaton', :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org2.categories << @category1
    @org2.categories << @category2
    @org2.save!
    @org3 = FactoryGirl.build(:organization, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org3.categories << @category1
    @org3.save!
  end

  it 'should have a human readable name and charity commission id and ridiculous name' do
    c = Category.new(:name => "Health",:charity_commission_id => 1, :charity_commission_name => "WELL BEING AND JOYOUS EXISTENCE")
    expect(c.name).to eq("Health")
    expect(c.charity_commission_id).to eq(1)
    expect(c.charity_commission_name).to eq("WELL BEING AND JOYOUS EXISTENCE")
  end

  it 'has and belongs to many organizations' do
    expect(@category1.organizations).to include(@org2)
    expect(@category1.organizations).to include(@org3)
  end
end