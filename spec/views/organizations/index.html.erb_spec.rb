require 'spec_helper'

describe "organizations/index.html.erb", :js => true do

  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha', :lat => 1, :lng => -1
  end

  let(:org2) do
    stub_model Organization,:name => 'test2', :address => "12 oxford rd", :postcode => "HA1 4HX", :telephone => "4534", :website => 'http://b.com', :description => 'I am ', :lat => 1, :lng => -1
  end

  let(:organizations) do
    [org1,org2]
  end

  let(:results) do
    [org1,org2]
  end

  before(:each) do
    assign(:organizations, organizations)
    assign(:results, results)
    assign(:query_term,'search')
    organizations.stub(:current_page).and_return(1)
    organizations.stub(:total_pages).and_return(1)
    organizations.stub(:limit_value).and_return(1)
    assign(:category_options, [['Animal Welfare','1'],['Education','2']])
    render
  end

  it "renders a search form" do
    rendered.should have_selector "form input[name='q']"
    rendered.should have_selector "form input[type='submit']"
    rendered.should have_selector "form input[value='search']"
    rendered.should have_selector "form input[placeholder='optional search name/description']"
    rendered.should have_selector "form select[name='category[id]']"
    rendered.should have_selector "form select[name='category[id]'] option[value='']" do |all_select|
      expect(all_select).to contain("All")
    end
    rendered.should have_selector "form select[name='category[id]'] option[value='1']"
    rendered.should have_selector "form select[name='category[id]'] option[value='2']"
  end

  it "render organization names with hyperlinks" do
    organizations.each do |org|
      rendered.should have_link org.name, :href => organization_path(org.id)
      rendered.should have_content org.description.truncate(128,:omission=>' ...')
    end
  end

  #TODO reactivate this test once the org info is sanitized
  #it "does not render addresses and telephone numbers" do
  #  rendered.should_not have_content org1.address
  #  rendered.should_not have_content org1.telephone
  #  rendered.should_not have_content org2.address
  #  rendered.should_not have_content org2.telephone
  #end

  it "does not renders edit and destroy links" do
    rendered.should_not have_link 'Edit'
    rendered.should_not have_link 'Destroy'
  end

  it 'renders a script with organization info as json' do
    rendered.should have_css 'script', text: "LocalSupport.maps.data = #{organizations.to_json}"
  end
end
