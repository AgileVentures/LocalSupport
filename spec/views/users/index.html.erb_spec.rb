require 'spec_helper'

describe "users/index.html.erb" do
  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha', :lat => 1, :lng => -1
  end
  let(:user1) do
    stub_model User,:email => 'pending@myorg.com', :pending_organization => :org1
  end
  before :each do
  end
  it 'shows the pending users' do
    render
    rendered.should have_content 'pending@myorg.com'
  end
  it 'has a link to approve users' do
    render
    rendered.should have_link "Approve", :href => '#'
  end
end
