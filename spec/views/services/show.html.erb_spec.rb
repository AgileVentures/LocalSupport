require 'rails_helper'

RSpec.describe "services/show", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      :contact_id => "Contact",
      :display_name => "Display Name",
      :service_activities => "MyText",
      :postal_code => "Postal Code",
      :office_main_phone_general_phone => "Office Main Phone General Phone",
      :office_main_email => "Office Main Email",
      :website => "Website",
      :delivered_by_organization_name => "Delivered By Organization Name",
      :where_we_work => "Where We Work",
      :self_care_one_to_one_or_group => "Self Care One To One Or Group",
      :self_care_service_category => "Self Care Service Category",
      :self_care_category_secondary => "Self Care Category Secondary",
      :self_care_service_agreed => "Self Care Service Agreed",
      :location_type => "Location Type",
      :street_address => "Street Address",
      :street_number => "Street Number",
      :street_name => "Street Name",
      :street_unit => "Street Unit",
      :supplemental_address_1 => "Supplemental Address 1",
      :supplemental_address_2 => "Supplemental Address 2",
      :supplemental_address_3 => "Supplemental Address 3",
      :city => "City",
      :latitude => 2,
      :longitude => 3,
      :address_name => "Address Name",
      :county => "County",
      :state => "State",
      :country => "Country",
      :groups => "Groups",
      :tags => "Tags",
      :activity_type => "Activity Type",
      :summary_of_activities => "Summary Of Activities",
      :beneficiaries => "Beneficiaries"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Contact/)
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Postal Code/)
    expect(rendered).to match(/Office Main Phone General Phone/)
    expect(rendered).to match(/Office Main Email/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/Delivered By Organization Name/)
    expect(rendered).to match(/Where We Work/)
    expect(rendered).to match(/Self Care One To One Or Group/)
    expect(rendered).to match(/Self Care Service Category/)
    expect(rendered).to match(/Self Care Category Secondary/)
    expect(rendered).to match(/Self Care Service Agreed/)
    expect(rendered).to match(/Location Type/)
    expect(rendered).to match(/Street Address/)
    expect(rendered).to match(/Street Number/)
    expect(rendered).to match(/Street Name/)
    expect(rendered).to match(/Street Unit/)
    expect(rendered).to match(/Supplemental Address 1/)
    expect(rendered).to match(/Supplemental Address 2/)
    expect(rendered).to match(/Supplemental Address 3/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Address Name/)
    expect(rendered).to match(/County/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Groups/)
    expect(rendered).to match(/Tags/)
    expect(rendered).to match(/Activity Type/)
    expect(rendered).to match(/Summary Of Activities/)
    expect(rendered).to match(/Beneficiaries/)
  end
end
