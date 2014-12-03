require 'rails_helper'
describe '/devise/sessions/new.html.erb', :type => :view do

  it 'includes org id in hidden field' do
    session[:pending_organisation_id] = 1
    render
    expect(rendered).to have_xpath("//input[@name = 'pending_organisation_id'][@value='1']")
  end
end
