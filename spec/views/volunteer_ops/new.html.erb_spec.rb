require 'spec_helper'

describe "volunteer_ops/new" do
  before(:each) do
    assign(:volunteer_op, stub_model(VolunteerOp,
      :title => "MyString",
      :description => "MyText",
      :organization => nil
    ).as_new_record)
  end

  it "renders new volunteer_op form" do
    render

    rendered.should have_selector("form", :action => volunteer_ops_path, :method => "post") do |form|
      form.should have_selector("input#volunteer_op_title", :name => "volunteer_op[title]")
      form.should have_selector("textarea#volunteer_op_description", :name => "volunteer_op[description]")
      form.should have_selector("input#volunteer_op_organization", :name => "volunteer_op[organization]")
    end
  end
end
