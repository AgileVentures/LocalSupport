require 'spec_helper'

describe "volunteer_ops/index", :js => true  do
  before(:each) do
    @org1 = stub_model(Organisation, :name => "The Addams Family",  
                      :address => "1313 Mockingbird Lane")
    @org2 = stub_model(Organisation, :name => "The Neighbors",  
                      :address => "666 Mockingbird Lane")
    @volunteer_ops = [(stub_model(VolunteerOp, :title => "Undertaker",
                      :description => "Help Uncle Fester", 
                      :organisation => @org1)),
                      (stub_model(VolunteerOp, :title => "Gravedigger",
                      :description => "Dispose of victims", 
                      :organisation => @org2))]
  end
  it "renders a list of volunteer_ops" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_content op.title
      rendered.should have_content op.description
      rendered.should have_content op.organisation.name
    end
  end

  it "renders a link to the volunteer_ops" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_link op.title, :href => volunteer_op_path(op.id)
    end
  end

  it "renders a link to the organisation" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_link op.organisation.name, :href => organisation_path(op.organisation.id)
    end
  end
  

  it "displays the javascript for a google map" do
    orgs = [@org1, @org2]
    assign(:footer_page_links, [])
    assign(:json, orgs.to_gmaps4rails)
    render template: "volunteer_ops/index", layout: "layouts/application"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
    rendered.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  end

end
