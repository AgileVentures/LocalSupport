require 'rails_helper'

describe "volunteer_ops/index", :type => :view, :js => true  do
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
      expect(rendered).to have_content op.title
      expect(rendered).to have_content op.description
      expect(rendered).to have_content op.organisation.name
    end
  end

  it "renders a link to the volunteer_ops" do
    render
    @volunteer_ops.each do |op|
      expect(rendered).to have_link op.title, :href => volunteer_op_path(op.id)
    end
  end

  it "renders a link to the organisation" do
    render
    @volunteer_ops.each do |op|
      expect(rendered).to have_link op.organisation.name, :href => organisation_path(op.organisation.id)
    end
  end

  it 'displays the json for the map script' do
    orgs = [@org1, @org2]
    assign(:footer_page_links, [])
    assign(:markers, 'my-markers')
    render template: "volunteer_ops/index", layout: "layouts/two_columns_with_map"
    expect(rendered).to include 'my-markers'
  end

  it "displays the javascript for a google map" do
    orgs = [@org1, @org2]
    assign(:footer_page_links, [])
    render template: "volunteer_ops/index", layout: "layouts/application"
    expect(rendered).to include 'google_map.js'
  end

end
