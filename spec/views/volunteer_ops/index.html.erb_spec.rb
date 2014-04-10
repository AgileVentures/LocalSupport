require 'spec_helper'

describe "volunteer_ops/index" do
  before(:each) do
    assign(:volunteer_ops, [
      stub_model(VolunteerOp,
        :title => "Title",
        :description => "MyText",
        :organization => nil
      ),
      stub_model(VolunteerOp,
        :title => "Title",
        :description => "MyText",
        :organization => nil
      )
    ])
  end

  it "renders a list of volunteer_ops" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
