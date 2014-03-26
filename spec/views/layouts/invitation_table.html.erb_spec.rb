require 'spec_helper'

describe 'layouts/invitation_table.html.erb' do
  before(:each) { render }
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
    rendered.should have_css('div[data-resend_invitation=true]')
  end
end