require 'spec_helper'

describe "organisations/_popup.html.erb" do
  let(:org) do
    stub_model Organisation, :name => "Friendly Charity", :id => 1, 
      :description => 'This is an absurdly absurdly long but very fun description that will make you sick '
  end

  before(:each) do
    assign(:org, org)
    render
  end

  it "should render a link to an org" do
    expect(rendered).to have_link 'Friendly Charity', :href => organisation_path(org)
  end
  
  it 'should render a description of org' do
     expect(rendered).to have_content(smart_truncate(org.description, 32))
  end
end