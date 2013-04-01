require 'spec_helper'

describe "organizations/show.html.erb" do
  before(:each) do
    @organization = assign(:organization, mock_model(Organization, :name => 'Friendly charity', :donation_info => 'http://www.friendly-charity.co.uk/donate'))
  end

  it "renders attributes in <p>" do
    render
  end

  it "renders donation info" do
    render
    rendered.should have_link "Donate to #{@organization.name} now!", :href => @organization.donation_info
  end
end
