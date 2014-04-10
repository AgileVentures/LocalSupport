require 'spec_helper'

describe "volunteer_ops/show" do
  before(:each) do
    @volunteer_op = assign(:volunteer_op, stub_model(VolunteerOp,
      :title => "Title",
      :description => "MyText",
      :organization => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(//)
  end
end
