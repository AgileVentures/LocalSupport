require 'spec_helper'

describe 'layouts/invitation_table.html.erb' do
  before do
    assign(:footer_page_links, [])
    assign :resend_invitation, true
    render
  end
  it 'toolbar' do
    rendered.within('#toolbar') do |toolbar|
      toolbar.should have_button 'Invite Users'
      toolbar.should have_button 'Select All'
    end
  end
  it 'well' do
    rendered.should have_css('div[class=well]')
  end
  it 'resend invitation variable' do
    rendered.should have_selector('//div[@data-resend_invitation=true]', :visible => false)
  end
end

