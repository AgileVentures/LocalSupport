require 'csv'
require 'active_support/all'
require_relative '../../app/models/first_capitals_humanizer'
require_relative '../../app/models/create_organization_from_array'

class Organization; end

describe CreateOrganizationFromArray, "#call" do 
  let(:service) { CreateOrganizationFromArray.new(row, mappings) }
  let(:mappings) do 
    {name: 'Title',
      address: 'Contact Address',
      description: 'Activities'}
  end
  let(:headers) do 
    'Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')
  end
  let(:fields) do 
    CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
  end
  let(:row) do 
    CSV::Row.new(headers, fields.flatten)
  end

  pending 'create Organization from csv file without running validations' do 
    let(:organization) { double(:organization) }
    before do 
      Organization.stub(:find_by_name) { organization }
    end
    subject { service.call(false) } 

    its(:name) { should == 'Harrow Baptist Church' }
  end

  pending 'should save Organization from file without running validations' do
    Gmaps4rails.should_not_receive(:geocode)
    org = Organization.create_from_array(row, false)
    expect(org.name).to eq('Harrow Baptist Church')
    expect(org.description).to eq('No information recorded')
    expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
    expect(org.postcode).to eq('HA1 1BA')
    expect(org.website).to eq('http://www.harrow-baptist.org.uk')
    expect(org.telephone).to eq('020 8863 7837')
    expect(org.donation_info).to eq(nil)
  end

end
