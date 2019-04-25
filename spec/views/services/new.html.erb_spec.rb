require 'rails_helper'

RSpec.describe "services/new", type: :view do
  before(:each) do
    assign(:service, Service.new(
      :contact_id => "MyString",
      :display_name => "MyString",
      :service_activities => "MyText",
      :postal_code => "MyString",
      :office_main_phone_general_phone => "MyString",
      :office_main_email => "MyString",
      :website => "MyString",
      :delivered_by_organization_name => "MyString",
      :where_we_work => "MyString",
      :self_care_one_to_one_or_group => "MyString",
      :self_care_service_category => "MyString",
      :self_care_category_secondary => "MyString",
      :self_care_service_agreed => "MyString",
      :location_type => "MyString",
      :street_address => "MyString",
      :street_number => "MyString",
      :street_name => "MyString",
      :street_unit => "MyString",
      :supplemental_address_1 => "MyString",
      :supplemental_address_2 => "MyString",
      :supplemental_address_3 => "MyString",
      :city => "MyString",
      :latitude => 1,
      :longitude => 1,
      :address_name => "MyString",
      :county => "MyString",
      :state => "MyString",
      :country => "MyString",
      :groups => "MyString",
      :tags => "MyString",
      :activity_type => "MyString",
      :summary_of_activities => "MyString",
      :beneficiaries => "MyString"
    ))
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do

      assert_select "input[name=?]", "service[contact_id]"

      assert_select "input[name=?]", "service[display_name]"

      assert_select "textarea[name=?]", "service[service_activities]"

      assert_select "input[name=?]", "service[postal_code]"

      assert_select "input[name=?]", "service[office_main_phone_general_phone]"

      assert_select "input[name=?]", "service[office_main_email]"

      assert_select "input[name=?]", "service[website]"

      assert_select "input[name=?]", "service[delivered_by_organization_name]"

      assert_select "input[name=?]", "service[where_we_work]"

      assert_select "input[name=?]", "service[self_care_one_to_one_or_group]"

      assert_select "input[name=?]", "service[self_care_service_category]"

      assert_select "input[name=?]", "service[self_care_category_secondary]"

      assert_select "input[name=?]", "service[self_care_service_agreed]"

      assert_select "input[name=?]", "service[location_type]"

      assert_select "input[name=?]", "service[street_address]"

      assert_select "input[name=?]", "service[street_number]"

      assert_select "input[name=?]", "service[street_name]"

      assert_select "input[name=?]", "service[street_unit]"

      assert_select "input[name=?]", "service[supplemental_address_1]"

      assert_select "input[name=?]", "service[supplemental_address_2]"

      assert_select "input[name=?]", "service[supplemental_address_3]"

      assert_select "input[name=?]", "service[city]"

      assert_select "input[name=?]", "service[latitude]"

      assert_select "input[name=?]", "service[longitude]"

      assert_select "input[name=?]", "service[address_name]"

      assert_select "input[name=?]", "service[county]"

      assert_select "input[name=?]", "service[state]"

      assert_select "input[name=?]", "service[country]"

      assert_select "input[name=?]", "service[groups]"

      assert_select "input[name=?]", "service[tags]"

      assert_select "input[name=?]", "service[activity_type]"

      assert_select "input[name=?]", "service[summary_of_activities]"

      assert_select "input[name=?]", "service[beneficiaries]"
    end
  end
end
