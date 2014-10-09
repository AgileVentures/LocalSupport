require 'spec_helper'

describe 'admin_mailer/new_user_waiting_for_approval.html.erb' do
  it 'should render with org name' do
    assign(:org_name, 'Friendly')
    render
    render.should have_content("There is a user waiting for admin approval to Friendly")
  end
end
