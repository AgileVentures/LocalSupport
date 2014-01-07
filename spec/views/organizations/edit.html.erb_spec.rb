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
            'Description' => 'Enter a full description here. When an individual searching this database all words in this description will be searched.',
            'Website' => 'Make sure url is correct',
            'Telephone' => 'Make sure phone number is correct',
            'Add an additional organisation administrator email' => 'Please enter the details of individuals from your organisation you would like to give permission to update your entry. E-mail addresses entered here will not be made public.',
            'Donation info' => 'Please enter a website here either to the fundraising page on your website or to an online donation site.'
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

it "renders a checkbox to make address public" do
  render
  debugger
  rendered.should should have_selector('input', :id => 'publish_address', :type => 'checkbox')
end

it "renders a checkbox to make phone number public" do
  render
  rendered.should should have_selector('publish_phone', :type => 'checkbox')
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
