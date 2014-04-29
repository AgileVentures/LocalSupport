require 'spec_helper'

describe 'layouts/invitation_table.html.erb' do
  before do
    assign(:footer_page_links, [])
  end
  it 'toolbar' do
    render
    rendered.within('#toolbar') do |toolbar|
      toolbar.should have_button 'Invite Users'
      toolbar.should have_button 'Select All'
    end
  end
  it 'well' do
    render
    rendered.should have_css('div[class=well]')
  end
end
