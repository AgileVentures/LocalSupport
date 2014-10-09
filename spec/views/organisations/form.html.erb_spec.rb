require 'spec_helper'

describe "organisations/_form.html.erb" do
  before :each do
    @organisation = Organisation.new
    render
  end
  it "renders form partial even for empty Organisation" do
    expect(rendered).not_to be_nil
  end

  it "renders the form with placeholders" do

    hash = {
            'organisation_name' => 'Enter organisation name',
            'organisation_address'  => 'Enter organisation address',
            'organisation_postcode' => 'Enter organisation post code',
            'organisation_email' => 'Enter organisation email address',
            'organisation_description' => 'Enter organisation description',
            'organisation_website' => 'Enter organisation website url',
            'organisation_telephone' => 'Enter organisation phone number',
            'organisation_admin_email_to_add' => "You may add an organisation administrator email here",
            'organisation_donation_info' => 'Enter organisation donation url'
    }
    hash.each do |label,placeholder|
      expect(rendered).to have_xpath("(//td/input|//td/textarea)[@id='#{label}'][@placeholder='#{placeholder}']")
    end
  end

end
