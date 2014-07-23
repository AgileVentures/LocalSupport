require 'spec_helper'
require 'debugger'


describe "organizations/_form.html.erb" do
  before :each do
    @organization = Organization.new
    render
  end
  it "renders form partial even for empty Organization" do
    expect(rendered).not_to be_nil
  end

  it "renders the form with placeholders" do

    hash = {
            'organization_name' => 'Enter organisation name',
            'organization_address'  => 'Enter organisation address',
            'organization_postcode' => 'Enter organisation post code',
            'organization_email' => 'Enter organisation email address',
            'organization_description' => 'Enter organisation description',
            'organization_website' => 'Enter organisation website url',
            'organization_telephone' => 'Enter organisation phone number',
            'organization_admin_email_to_add' => "You may add an organisation administrator email here",
            'organization_donation_info' => 'Enter organisation donation url'
    }
    hash.each do |label,placeholder|
      expect(rendered).to have_xpath("(//td/input|//td/textarea)[@id='#{label}'][@placeholder='#{placeholder}']")
    end
  end

end
