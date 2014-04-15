require 'spec_helper'

describe "volunteer_ops/edit" do
  before(:each) do
    @volunteer_op = assign(:volunteer_op, stub_model(VolunteerOp,
      :title => "MyString",
      :description => "MyText",
      :organization => nil
    ))
  end

  it "renders the edit volunteer_op form" do
    pending "No cucumber feature for edit view yet"
    render


    rendered.should have_selector("form", :action => volunteer_op_path(@volunteer_op), :method => "post") do |form|
      form.should have_selector("input#volunteer_op_title", :name => "volunteer_op[title]")
      form.should have_selector("textarea#volunteer_op_description", :name => "volunteer_op[description]")
      form.should have_selector("input#volunteer_op_organization", :name => "volunteer_op[organization]")
    end
  end
end
