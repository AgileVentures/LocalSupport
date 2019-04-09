require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      :delivered_by_organization_name => "MyString",
      :display_name => "MyString",
      :self_care_one_to_one_or_group => "MyString",
      :service_activities => "MyText",
      :self_care_service_category => "MyString",
      :self_care_category_secondary => "MyString",
      :office_main_phone_general_phone => "MyString",
      :office_main_email => "MyString",
      :self_care_service_agreed => "MyString",
      :where_we_work => "MyString",
      :website => "MyString",
      :contact_id => "MyString"
    ))
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", service_path(@service), "post" do

      assert_select "input[name=?]", "service[delivered_by_organization_name]"

      assert_select "input[name=?]", "service[display_name]"

      assert_select "input[name=?]", "service[self_care_one_to_one_or_group]"

      assert_select "textarea[name=?]", "service[service_activities]"

      assert_select "input[name=?]", "service[self_care_service_category]"

      assert_select "input[name=?]", "service[self_care_category_secondary]"

      assert_select "input[name=?]", "service[office_main_phone_general_phone]"

      assert_select "input[name=?]", "service[office_main_email]"

      assert_select "input[name=?]", "service[self_care_service_agreed]"

      assert_select "input[name=?]", "service[where_we_work]"

      assert_select "input[name=?]", "service[website]"

      assert_select "input[name=?]", "service[contact_id]"
    end
  end
end
