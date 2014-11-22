require 'rails_helper'

describe 'user_reports/invited.html.erb', :type => :view do
  let(:invitation) { { id: '2', name: 'Harrow Charity', email: 'hello@there.com', date: Time.now } }
  before(:each) { assign(:invitations, [invitation]) }

  it 'columns: org name, email, date, checkbox' do
    render
    rendered.within("##{invitation[:id]}") do |row|
      expect(row).to have_link invitation[:name], :href => organisation_path(invitation[:id])
      expect(row).to have_text invitation[:email]
      expect(row).to have_text 'less than a minute'
      expect(row).to have_css("input[type=checkbox][data-id='#{invitation[:id]}'][data-email='#{invitation[:email]}']")
    end
  end
end
