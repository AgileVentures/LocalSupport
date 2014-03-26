require 'spec_helper'

describe 'organization_reports/without_users_index.html.erb' do
  let(:org) { stub_model Organization, id: '2', name: 'test', email: 'hello@there.com' }
  before(:each) { assign(:orphans, [org]) }

  it 'toolbar' do
    render
    rendered.within('#toolbar') do |toolbar|
      toolbar.should have_button 'Invite Users'
      toolbar.should have_button 'Select All'
    end
  end
  it 'columns: name, email, checkbox' do
    render
    rendered.within("##{org.id}") do |row|
      row.should have_link org.name, :href => organization_path(org.id)
      row.should have_text org.email
      row.should have_css('input[type=checkbox]')
    end
  end
end