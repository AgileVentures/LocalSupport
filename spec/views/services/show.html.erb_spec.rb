require 'rails_helper'

RSpec.describe "services/show", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Delivered By Organization Name/)
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/Self Care One To One Or Group/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Self Care Service Category/)
    expect(rendered).to match(/Self Care Category Secondary/)
    expect(rendered).to match(/Office Main Phone General Phone/)
    expect(rendered).to match(/Office Main Email/)
    expect(rendered).to match(/Self Care Service Agreed/)
    expect(rendered).to match(/Where We Work/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/Contact/)
  end
end
