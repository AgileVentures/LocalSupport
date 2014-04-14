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
    rendered.should contain("Title".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain(nil.to_s)
  end
end
