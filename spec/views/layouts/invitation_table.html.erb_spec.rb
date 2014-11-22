require 'rails_helper'

describe 'layouts/invitation_table.html.erb', :type => :view do
  before do
    assign(:footer_page_links, [])
    assign :resend_invitation, true
    render
  end
  it 'toolbar' do
    rendered.within('#toolbar') do |toolbar|
      expect(toolbar).to have_button 'Invite Users'
      expect(toolbar).to have_button 'Select All'
    end
  end
  it 'well' do
    expect(rendered).to have_css('div[class=well]')
  end
  it 'resend invitation variable' do
    expect(rendered).to have_selector('//div[@data-resend_invitation=true]', :visible => false)
  end
end

