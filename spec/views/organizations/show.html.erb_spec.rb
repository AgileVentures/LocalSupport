require 'spec_helper'

describe "organizations/show.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization))
  end

  it "renders attributes in <p>" do
    render
  end
end
