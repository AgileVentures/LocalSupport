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
    rendered.should have_selector("tr>td", :content => "Title".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => nil.to_s, :count => 2)
  end
end
