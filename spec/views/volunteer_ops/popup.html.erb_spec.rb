require 'spec_helper'

describe "volunteer_ops/_popup.html.erb" do
  let(:org) do
    stub_model Organization, :name => "Friendly Charity", :id => 1, 
      :description => 'This is an absurdly absurdly long but very fun description that will make you sick '
  end
  let(:op1) do
    stub_model VolunteerOp, :title => "Friendly Volunteer", :organization_id => org.id, :id => 1, 
      :description => 'Friendly people wanted!  This is an absurdly absurdly long but very fun description that will make you sick '
  end
  let(:op2) do
    stub_model VolunteerOp, :title => "Friendly Driver", :organization_id => org.id, :id => 1, 
      :description => 'Drivers wanted!  This is an absurdly absurdly long but very fun description that will make you sick '
  end

  before(:each) do
    VolunteerOp.stub(:find_all_by_organization_id).and_return([op1, op2])
    assign(:org, org)
    render
  end

  it "should render a link to each volunteer opportunity at that org" do
    expect(rendered).to have_link 'Friendly Volunteer', :href => volunteer_op_path(op1)
    expect(rendered).to have_link 'Friendly Driver', :href => volunteer_op_path(op2)
  end
  
  it 'should render a description of a volunteer opportunity' do
     expect(rendered).to have_content(smart_truncate(op1.description, 32))
     expect(rendered).to have_content(smart_truncate(op2.description, 32))
  end
  
  it "should render a link to an org" do
    expect(rendered).to have_link 'Friendly Charity', :href => organization_path(org)
  end
  
  it 'should not render a description of org' do
     expect(rendered).not_to have_content(smart_truncate(org.description, 32))
  end
end
