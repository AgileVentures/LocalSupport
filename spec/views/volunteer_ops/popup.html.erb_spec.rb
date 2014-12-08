require 'rails_helper'

describe "volunteer_ops/_popup.html.erb", :type => :view do
  let(:org) do
    stub_model Organisation, :name => "Friendly Charity", :id => 1, 
      :description => 'This is an absurdly absurdly long but very fun description that will make you sick '
  end
  let(:op1) do
    stub_model VolunteerOp, :title => "Friendly Volunteer", :organisation_id => org.id, :id => 1, 
      :description => 'Friendly people wanted!  This is an absurdly absurdly long but very fun description that will make you sick '
  end
  let(:op2) do
    stub_model VolunteerOp, :title => "Friendly Driver", :organisation_id => org.id, :id => 1, 
      :description => 'Drivers wanted!  This is an absurdly absurdly long but very fun description that will make you sick '
  end

  before(:each) do
    allow(VolunteerOp).to receive(:where).and_return([op1, op2])
    render partial: "popup.html.erb", locals: {org: org}
  end

  it "should render a link to each volunteer opportunity at that org" do
    expect(rendered).to have_link 'Friendly Volunteer', :href => volunteer_op_path(op1)
    expect(rendered).to have_link 'Friendly Driver', :href => volunteer_op_path(op2)
  end
  
  it 'should render a description of a volunteer opportunity' do
     expect(rendered).to have_content(smart_truncate(op1.description, 42))
     expect(rendered).to have_content(smart_truncate(op2.description, 42))
  end
  
  it "should render a link to an org" do
    expect(rendered).to have_link 'Friendly Charity', :href => organisation_path(org)
  end
  
  it 'should not render a description of org' do
     expect(rendered).not_to have_content(smart_truncate(org.description, 42))
  end
end
