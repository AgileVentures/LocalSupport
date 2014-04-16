require 'spec_helper'

describe "volunteer_ops/index" do
  before(:each) do
    @org = stub_model(Organization, :name => "The Adams Family",  
                      :address => "666 Mockingbird Lane")
    @volunteer_ops = [(stub_model(VolunteerOp, :title => "Undertaker",
                      :description => "Help Uncle Fester", 
                      :organization => @org)),
                      (stub_model(VolunteerOp, :title => "Gravedigger",
                      :description => "Dispose of victims", 
                      :organization => @org))]
  end

  it "renders a list of volunteer_ops" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_content op.title
      rendered.should have_content op.description
      rendered.should have_content op.organization.name
    end
  end

#  it "renders table for organizations scrolling" do
#    render
#    rendered.should have_selector('div', :class => "container")
#  end
#
#
##  <div class="row">
##  <div id="column1" class="span6">
##  <%= yield :map %>
##  </div>
##  <div id="column2" class="span6">
##  <%= yield %>
##  </div>
##</div>
##<%= parent_layout 'application' %>

end
