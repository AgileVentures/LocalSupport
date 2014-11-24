require 'rails_helper'

describe 'organisation_reports/without_users_index.html.erb', :type => :view do
  let(:org) { stub_model Organisation, id: '2', name: 'test', email: 'hello@there.com' }
  before(:each) { assign(:orphans, [org]) }

  it 'columns: name, email, checkbox' do
    render
    rendered.within("##{org.id}") do |row|
      expect(row).to have_link org.name, :href => organisation_path(org.id)
      expect(row).to have_text org.email
      expect(row).to have_css("input[type=checkbox][data-id='#{org.id}'][data-email='#{org.email}']")
    end
  end
end
