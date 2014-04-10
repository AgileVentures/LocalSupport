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
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", volunteer_op_path(@volunteer_op), "post" do
      assert_select "input#volunteer_op_title[name=?]", "volunteer_op[title]"
      assert_select "textarea#volunteer_op_description[name=?]", "volunteer_op[description]"
      assert_select "input#volunteer_op_organization[name=?]", "volunteer_op[organization]"
    end
  end
end
