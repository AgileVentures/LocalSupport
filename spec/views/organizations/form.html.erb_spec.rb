require 'spec_helper'
require 'debugger'


describe "organizations/_form.html.erb" do

  it "renders form partial even for empty Organization" do
    @organization = Organization.new
    render
  end

  it "renders the form with placeholders" do
    @organization = Organization.new

    render

    hash = {
            'organization_name' => 'Enter organisation name',
            'organization_address'  => 'Enter organisation address',
            'organization_postcode' => 'Enter organisation post code',
            'organization_email' => 'Enter organisation email address',
            'organization_description' => 'Enter organisation description',
            'organization_website' => 'Enter organisation website url',
            'organization_telephone' => 'Enter organisation phone number',
            'organization_admin_email_to_add' => "Enter optional additional organisation administrator email",
            'organization_donation_info' => 'Enter organisation donation url'
    }
    hash.each do |label,placeholder|
      debugger
      expect(rendered).to have_xpath("(//td/input|//td/textarea)[@id='#{label}'][@placeholder='#{placeholder}']")
      #expect(rendered).to have_xpath("//td/input[@id='#{label}'][@placeholder='#{placeholder}']")
    end
  end

  it "allows placeholder to be overwritten" do
    @organization = Organization.new({:email => "DannyThomas@weirdly.com"})
    render
    expect(rendered).to have_xpath("//td/input[@id='organization_email'][@value='DannyThomas@weirdly.com']")
  end

end
