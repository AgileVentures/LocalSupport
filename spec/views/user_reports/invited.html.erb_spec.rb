require 'spec_helper'

describe 'user_reports/invited.html.erb' do
  let(:invitation) { { id: '2', name: 'Harrow Charity', email: 'hello@there.com', date: Time.now } }
  before(:each) { assign(:invitations, [invitation]) }

  it 'columns: org name, email, date, checkbox' do
    render
    rendered.within("##{invitation[:id]}") do |row|
      row.should have_link invitation[:name], :href => organisation_path(invitation[:id])
      row.should have_text invitation[:email]
      row.should have_text 'less than a minute'
      row.should have_css("input[type=checkbox][data-id='#{invitation[:id]}'][data-email='#{invitation[:email]}']")
    end
  end
end
