require 'rails_helper'

describe 'admin_mailer/new_user_waiting_for_approval.html.erb', :type => :view do
  it 'should render with org name' do
    assign(:org_name, 'Friendly')
    render
    expect(render).to have_content("There is a user waiting for superadmin approval to Friendly")
  end
end
