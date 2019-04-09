require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
        :delivered_by_organization_name => "Delivered By Organization Name",
        :display_name => "Display Name",
        :self_care_one_to_one_or_group => "Self Care One To One Or Group",
        :service_activities => "MyText",
        :self_care_service_category => "Self Care Service Category",
        :self_care_category_secondary => "Self Care Category Secondary",
        :office_main_phone_general_phone => "Office Main Phone General Phone",
        :office_main_email => "Office Main Email",
        :self_care_service_agreed => "Self Care Service Agreed",
        :where_we_work => "Where We Work",
        :website => "Website",
        :contact_id => "Contact"
      ),
      Service.create!(
        :delivered_by_organization_name => "Delivered By Organization Name",
        :display_name => "Display Name",
        :self_care_one_to_one_or_group => "Self Care One To One Or Group",
        :service_activities => "MyText",
        :self_care_service_category => "Self Care Service Category",
        :self_care_category_secondary => "Self Care Category Secondary",
        :office_main_phone_general_phone => "Office Main Phone General Phone",
        :office_main_email => "Office Main Email",
        :self_care_service_agreed => "Self Care Service Agreed",
        :where_we_work => "Where We Work",
        :website => "Website",
        :contact_id => "Contact"
      )
    ])
  end

  it "renders a list of services" do
    render
    assert_select "tr>td", :text => "Delivered By Organization Name".to_s, :count => 2
    assert_select "tr>td", :text => "Display Name".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care One To One Or Group".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Service Category".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Category Secondary".to_s, :count => 2
    assert_select "tr>td", :text => "Office Main Phone General Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Office Main Email".to_s, :count => 2
    assert_select "tr>td", :text => "Self Care Service Agreed".to_s, :count => 2
    assert_select "tr>td", :text => "Where We Work".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Contact".to_s, :count => 2
  end
end
