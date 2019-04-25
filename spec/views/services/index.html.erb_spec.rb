require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
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
      ),
      Service.create!(
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
      )
    ])
  end

  it "renders a list of services" do
    render
    assert_select "tr>td", :text => "Contact".to_s, :count => 2
    assert_select "tr>td", :text => "Display Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Postal Code".to_s, :count => 2
    assert_select "tr>td", :text => "Office Main Phone General Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Office Main Email".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Delivered By Organization Name".to_s, :count => 2
    assert_select "tr>td", :text => "Where We Work".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care One To One Or Group".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Service Category".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Category Secondary".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Service Agreed".to_s, :count => 2
    assert_select "tr>td", :text => "Location Type".to_s, :count => 2
    assert_select "tr>td", :text => "Street Address".to_s, :count => 2
    assert_select "tr>td", :text => "Street Number".to_s, :count => 2
    assert_select "tr>td", :text => "Street Name".to_s, :count => 2
    assert_select "tr>td", :text => "Street Unit".to_s, :count => 2
    assert_select "tr>td", :text => "Supplemental Address 1".to_s, :count => 2
    assert_select "tr>td", :text => "Supplemental Address 2".to_s, :count => 2
    assert_select "tr>td", :text => "Supplemental Address 3".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Address Name".to_s, :count => 2
    assert_select "tr>td", :text => "County".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Groups".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
    assert_select "tr>td", :text => "Activity Type".to_s, :count => 2
    assert_select "tr>td", :text => "Summary Of Activities".to_s, :count => 2
    assert_select "tr>td", :text => "Beneficiaries".to_s, :count => 2
  end
end
