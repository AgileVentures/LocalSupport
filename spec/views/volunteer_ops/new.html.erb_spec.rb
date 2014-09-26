require 'spec_helper'

describe "volunteer_ops/new" do
  let (:organisation) { double :organisation, id: 3 }
  let (:user) { double :user, organisation: organisation } 
  before(:each) do
    assign(:volunteer_op, stub_model(VolunteerOp,
      :title => "MyString",
      :description => "MyText",
      :organisation => nil
    ).as_new_record)
    params[:organisation_id] = 4
    #view.stub current_user: user
  end

  it "renders new volunteer_op form" do
    render
    rendered.should have_selector("form", :action => organisation_volunteer_ops_path(organisation_id: 4), :method => "post") do |form|
      form.should have_selector("input#volunteer_op_title", :name => "volunteer_op[title]")
      form.should have_selector("textarea#volunteer_op_description", :name => "volunteer_op[description]")
    end
  end

  it "should have a Create Volunteer Opportunity button" do
    render
    rendered.should have_css 'input[value="Create a Volunteer Opportunity"]'
  end

  it "only has 1 text area and 1 text input" do
    render
    rendered.should have_css("textarea", :count => 1 )
    rendered.should have_css("input[type=text]", :count => 1 )
  end
end
