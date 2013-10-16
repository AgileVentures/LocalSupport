require 'spec_helper'

describe "organizations/edit.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
                                                     :new_record? => false, :donation_info => "http://www.friendly.com/donate"
    ))
  end

  it "renders the edit organization form" do
    view.lookup_context.prefixes = %w[organizations application]
    render

    rendered.should have_selector("form", :action => organization_path(@organization), :method => "post") do |form|
    end
  end

  it "renders the edit organization form with tooltips" do
    view.lookup_context.prefixes = %w[organizations application]

    render

    hash = {'Name' => 'Enter a unique name',
            'Address'  => 'Enter a complete address',
            'Postcode' => 'Make sure post code is accurate',
            'Email' => 'Make sure email is correct',
            'Description' => 'Enter a detailed description',
            'Website' => 'Make sure url is correct',
            'Telephone' => 'Make sure phone number is correct',
            'Add an additional organisation administrator email' => 'Administrator email'
            }
    hash.each do |label,tooltip|
      rendered.should have_css("div[title=\"#{tooltip}\"][data-toggle=\"tooltip\"]:contains('#{label}')")
    end
  end


it "renders the donation_info url in edit form" do
  render
  rendered.should have_field :organization_donation_info,
                             :with => "http://www.friendly.com/donate"
end

it "renders a form field to add an administrator email" do
  render
  rendered.should have_field :organization_admin_email_to_add
end

it 'renders an update button with Anglicized spelling of Organisation' do
  render
  rendered.should have_selector("input", :type => "submit", :value => "Update Organisation")
end
#todo: move this into proper integration test to avoid the errors mocking
#out being coupled with rails
it 'renders errors without prefatory error message' do
  errors = double("errors", :any? => true, :count => 1, :full_messages => ["Sample error"], :[] => double("somethingRailsExpects", :any? => false))
  org = stub_model(Organization)
  org.stub(:errors => errors)
  @organization = assign(:organization, org)
  render
  render.should have_content("Sample error")
  render.should_not have_content("1 error prohibited this organization from being saved:")
end
end
