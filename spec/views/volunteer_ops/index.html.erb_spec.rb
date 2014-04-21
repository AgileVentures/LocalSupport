require 'spec_helper'

describe "volunteer_ops/index" do
  before(:each) do
    @org = stub_model(Organization, :name => "The Addams Family",  
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

  it "renders a link to the volunteer_ops" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_link(href: volunteer_op_path(op))
    end
  end

  it "renders a link to the organization" do
    render
    @volunteer_ops.each do |op|
      rendered.should have_content op.title
      rendered.should have_content op.description
      rendered.should have_content op.organization.name
    end
  end


end
