require 'spec_helper'

describe 'user_reports/index.html.erb' do
  let(:org1) do
    stub_model Organisation,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organisation hahahahahhahaha', :lat => 1, :lng => -1
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
  context 'organisation shown' do
    it 'shows organisation if the user has one' do
      user.stub(:organisation).and_return(org1)
      render
      rendered.should have_content org1.name
    end
    it 'does not show organisation if the user does not have one' do
      render
      rendered.should_not have_content org1.name
    end
  end
  context 'pending organisation shown' do
    it 'shows a pending organisation if the user has one' do
      user.stub(:pending_organisation).and_return(org1)
      render
      rendered.should have_content org1.name
    end
    it 'does not show a pending organisation if the user does not have one' do
      render
      rendered.should_not have_content org1.name
    end
  end
  context 'approve link shown' do
    it 'approve link if user has pending organisation' do
      user.stub(:pending_organisation).and_return(org1)
      render
      rendered.should have_link "Approve", :href => user_report_path(id: user.id)
    end
    it 'no approve link if user has no pending organisation' do
      render
      rendered.should_not have_link "Approve"
    end
  end
  context 'delete link shown' do
    it 'for every user' do
      render
      rendered.should have_link "Delete", :href => user_reports_path(id: user.id)
    end
  end

end
