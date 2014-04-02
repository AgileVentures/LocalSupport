require 'spec_helper'

describe 'user_reports/invited.html.erb' do
  let(:invitation) { { id: '2', name: 'Harrow Charity', email: 'hello@there.com', date: '8 days' } }
  before(:each) { assign(:invitations, [invitation]) }

  it 'columns: org name, email, date, checkbox' do
    render
    rendered.within("##{invitation[:id]}") do |row|
      row.should have_link invitation[:name], :href => organization_path(invitation[:id])
      row.should have_text invitation[:email]
      row.should have_text invitation[:date]
      row.should have_css('input[type=checkbox]')
    end
  end
end