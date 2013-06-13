require 'spec_helper'

describe "organizations/index.html.erb", :js => true do

  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha'
  end

  let(:org2) do
    stub_model Organization,:name => 'test2', :address => "12 oxford rd", :postcode => "HA1 4HX", :telephone => "4534", :website => 'http://b.com', :description => 'I am '
  end

  let(:organizations) do
    [org1,org2]
  end

  before(:each) do
    assign(:organizations, organizations)
    organizations.stub!(:current_page).and_return(1)
    organizations.stub!(:total_pages).and_return(1)
    organizations.stub!(:limit_value).and_return(1)
  end

  it "renders a search form" do
    render
    rendered.should have_selector "form input[name='q']"
    rendered.should have_selector "form input[type='submit']"
  end

  it "render organization names with hyperlinks" do
    render
    organizations.each do |org|
      rendered.should have_link org.name, :href => organization_path(org.id)
      rendered.should have_content org.description.truncate(128,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    render
    rendered.should_not have_content org1.address
    rendered.should_not have_content org1.telephone
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    render
    rendered.should_not have_link 'Edit'
    rendered.should_not have_link 'Destroy'
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  # not sure if we can test generation of javascript here
  xit "displays the javascript for a google map" do
    assign(:json, organizations.to_gmaps4rails)
    render
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  end

end
