require 'spec_helper'

describe Organization do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @org1 = FactoryGirl.build(:organization, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org1.save!
    @org2 = FactoryGirl.build(:organization, :name => 'Indian Elders Associaton', :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org2.save!
    @org3 = FactoryGirl.build(:organization, :name => 'Age UK', :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    Gmaps4rails.should_receive(:geocode)
    @org3.save!
  end

  it 'must be able to humanize description' do
    expect(Organization.humanize_description('THIS IS A GOVERNMENT STRING')).to eq('This is a government string')
  end

  it 'must be able to humanize nil description' do
    expect(Organization.humanize_description(nil)).to eq(nil)
  end

  it 'must be able to extract postcode and address' do
    expect(Organization.parse_address('HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA')).to eq({:address => 'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => 'HA1 1BA'})
  end

  it 'must be able to handle postcode extraction when no postcode' do
    expect(Organization.parse_address('HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW')).to eq({:address =>'HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW', :postcode => ''})
  end
  
  it 'must be able to handle postcode extraction when nil address' do
     expect(Organization.parse_address(nil)).to eq({:address =>'', :postcode => ''})
  end

  it 'can humanize with all first capitals' do
    expect("HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW".humanized_all_first_capitals).to eq("Harrow Baptist Church, College Road, Harrow")
  end

  it 'must be able to generate multiple Organizations from text file' do
    number_to_import = 1006
    Gmaps4rails.should_receive(:geocode).exactly(number_to_import)
    lambda {
      Organization.import_addresses 'db/data.csv', number_to_import   
    }.should change(Organization, :count).by(number_to_import)
  end

  it 'must be able to handle no postcode in text representation' do
    Gmaps4rails.should_receive(:geocode)
    text = 'HARROW BAPTIST CHURCH,NO INFORMATION RECORDED,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837'
    org = Organization.create_from_array(CSV.parse(text)[0])
    expect(org.name).to eq('Harrow Baptist Church')
    expect(org.description).to eq('No information recorded')
    expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
    expect(org.postcode).to eq('')
    expect(org.website).to eq('http://www.harrow-baptist.org.uk')
    expect(org.telephone).to eq('020 8863 7837')
    expect(org.donation_info).to eq(nil)
  end

  it 'must be able to handle no address in text representation' do
    Gmaps4rails.should_receive(:geocode)
    text = 'HARROW BAPTIST CHURCH,NO INFORMATION RECORDED,,http://www.harrow-baptist.org.uk,020 8863 7837'
    org = Organization.create_from_array(CSV.parse(text)[0])
    expect(org.name).to eq('Harrow Baptist Church')
    expect(org.description).to eq('No information recorded')
    expect(org.address).to eq('')
    expect(org.postcode).to eq('')
    expect(org.website).to eq('http://www.harrow-baptist.org.uk')
    expect(org.telephone).to eq('020 8863 7837')
    expect(org.donation_info).to eq(nil)
  end

  it 'must be able to generate Organization from text representation ensuring words in correct case and postcode is extracted from address' do
    Gmaps4rails.should_receive(:geocode)
    text = 'HARROW BAPTIST CHURCH,NO INFORMATION RECORDED,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837'
    org = Organization.create_from_array(CSV.parse(text)[0])
    expect(org.name).to eq('Harrow Baptist Church')
    expect(org.description).to eq('No information recorded')
    expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
    expect(org.postcode).to eq('HA1 1BA')
    expect(org.website).to eq('http://www.harrow-baptist.org.uk')
    expect(org.telephone).to eq('020 8863 7837')
    expect(org.donation_info).to eq(nil)
  end

  it 'must have search by keyword' do
    Organization.should respond_to(:search_by_keyword)
  end

  it 'find all orgs that have keyword anywhere in their name or description' do
    Organization.search_by_keyword("elderly").should == [@org2, @org3]
  end
  
  it 'should have gmaps4rails_option hash with :check_process set to false' do
    @org1.gmaps4rails_options[:check_process].should == false
  end

  it 'should geocode when address changes' do
    new_address = '60 pinner road'
    Gmaps4rails.should_receive(:geocode).with("#{new_address}, #{@org1.postcode}", "en", false,"http")
    @org1.update_attributes :address => new_address
  end

it 'should geocode when new object is created' do
    address = '60 pinner road'
    postcode = 'HA1 3RE'
    Gmaps4rails.should_receive(:geocode).with("#{address}, #{postcode}", "en", false, "http")
    org = FactoryGirl.build(:organization,:address => address, :postcode => postcode, :name => 'Happy and Nice', :gmaps => true)
    org.save
  end
end
