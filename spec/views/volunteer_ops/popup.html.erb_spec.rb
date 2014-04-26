require 'spec_helper'

describe "volunteer_ops/_popup.html.erb" do
  let(:org) do
    stub_model Organization, :name => "Friendly Charity", :id => 1, 
      :description => 'This is an absurdly absurdly long but very fun description that will make you sick '
  end
  let(:op) do
    stub_model VolunteerOp, :title => "Friendly Volunteer", :organization => org, :id => 1, 
      :description => 'Hello!  This is an absurdly absurdly long but very fun description that will make you sick '
  end

  before(:each) do
    assign(:op, op)
    assign(:org, org)
    render
  end

  it "should render a link to a volunteer opportunity" do
    expect(rendered).to have_link 'Friendly Volunteer', :href => volunteer_op_path(op)
  end
  
  it 'should not render a description of a volunteer opportunity' do
     expect(rendered).to have_content(smart_truncate(op.description, 32))
  end
  
  it "should render a link to an org" do
    expect(rendered).to have_link 'Friendly Charity', :href => organization_path(org)
  end
  
  it 'should not render a description of org' do
     expect(rendered).not_to have_content(smart_truncate(org.description, 32))
  end
end
