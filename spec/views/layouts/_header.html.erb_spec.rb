require 'rails_helper'
describe '/layouts/_header.html.erb', :type => :view do

  it 'includes org id in hidden field' do
    assign(:organisation, stub_model(Organisation, :id => 1))
    render :partial => "layouts/header.html.erb"
    expect(rendered).to have_xpath("//input[@id = 'user_organisation_id'][@value='1']")
  end
  it 'handles no org gracefully' do
    render :partial => "layouts/header.html.erb"
    expect(rendered).not_to have_xpath("//input[@id = 'user_organisation_id']")
  end
end
