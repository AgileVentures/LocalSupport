require 'spec_helper'
describe '/layouts/_header.html.erb' do

  it 'includes org id in hidden field' do
    assign(:organization, stub_model(Organization, :id => 1))
    render :partial => "layouts/header.html.erb"
    rendered.should have_xpath("//input[@id = 'user_organization_id'][@value='1']")
  end
  it 'handles no org gracefully' do
    render :partial => "layouts/header.html.erb"
    rendered.should_not have_xpath("//input[@id = 'user_organization_id']")
  end
end