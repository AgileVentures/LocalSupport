require 'spec_helper'

describe 'user_reports/index.html.erb' do
  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha', :lat => 1, :lng => -1
  end
  let(:user) do
    stub_model User,:email => 'pending@myorg.com'
  end
  #let(:user2) do
  #  stub_model User,:email => 'not_pending@myorg.com'
  #end
  before :each do
    assign(:users, [user])
  end
  it 'shows the pending users' do
    render
    rendered.should have_content 'pending@myorg.com'
  end
  context 'organization shown' do
    it 'shows organization if the user has one' do
      user.stub(:organization).and_return(org1)
      render
      rendered.should have_content org1.name
    end
    it 'does not show organization if the user does not have one' do
      render
      rendered.should_not have_content org1.name
    end
  end
  context 'pending organization shown' do
    it 'shows a pending organization if the user has one' do
      user.stub(:pending_organization).and_return(org1)
      render
      rendered.should have_content org1.name
    end
    it 'does not show a pending organization if the user does not have one' do
      render
      rendered.should_not have_content org1.name
    end
  end
  context 'approve link shown' do
    it 'approve link if user has pending organization' do
      user.stub(:pending_organization).and_return(org1)
      render
      rendered.should have_link "Approve", :href => user_path(id: user.id)
    end
    it 'no approve link if user has no pending organization' do
      render
      rendered.should_not have_link "Approve"
    end
  end

end
