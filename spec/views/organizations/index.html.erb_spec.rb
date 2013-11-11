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
    assign(:json, organizations.to_gmaps4rails)
    render template: "organizations/index", layout: "layouts/application"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  end

  it "does not render a new organization link for non-logged in user"  do
    view.stub(:user_signed_in? => false)
    render
    rendered.should_not have_xpath("//a[@href='#{new_organization_path}']")
  end

  it "does not render a new organization link for logged in user"  do
    @user = double('user')
    @user.stub(:id => 100)
    view.stub(:current_user) {@user}
    view.stub(:user_signed_in? => true)
    @user.should_receive(:try).with(:admin?).and_return(false)
    render
    rendered.should_not have_xpath("//a[@href='#{new_organization_path}']")
  end

  it "does render a new organization link for logged in admin user"  do
    @user = double('user')
    @user.stub(:id => 100)
    view.stub(:current_user) {@user}
    @user.should_receive(:try).with(:admin?).and_return(true)
    render
    rendered.should have_xpath("//a[@href='#{new_organization_path}']")
  end

end
