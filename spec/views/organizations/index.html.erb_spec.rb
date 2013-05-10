require 'spec_helper'

describe "organizations/index.html.erb" do

  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha'
  end

  let(:org2) do
    stub_model Organization,:name => 'test2', :address => "12 oxford rd", :telephone => "4534", :website => 'http://b.com', :description => 'I am '
  end

  let(:organizations) do
    [org1,org2]
  end

  before(:each) do
    render
    assign(:organizations, organizations)
  end

  it "renders a search form" do
    rendered.should have_selector "form input[name='q']"
    rendered.should have_selector "form input[type='submit']"
  end

  it "render organization names with hyperlinks" do
    organizations.each do |org|
      rendered.should have_link org.name, :href => organization_path(org.id)
      rendered.should have_content org.description.truncate(24,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    rendered.should_not have_content org1.address
    rendered.should_not have_content org1.telephone
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    rendered.should_not have_link 'Edit'
    rendered.should_not have_link 'Destroy'
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it "displays the javascript for a google map" do
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 13')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  end

end
