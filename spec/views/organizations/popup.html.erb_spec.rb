require 'spec_helper'

describe "organizations/_popup.html.erb" do
  let(:org) do
    stub_model Organization, :name => "Friendly Charity", :id => 1
  end

  before(:each) do
    assign(:org, org)
    render
  end

  it "should render a link to an org" do
    expect(rendered).to have_link 'Friendly Charity', :href => organization_path(org)
  end
end