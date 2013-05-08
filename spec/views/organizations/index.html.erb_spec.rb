require 'spec_helper'

describe "organizations/index.html.erb" do

  let(:org1) do
    stub_model Organization,:name => 'test', :address => "12 pinner rd", :telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha'
  end

  let(:org2) do
    stub_model Organization,:name => 'test2', :address => "12 oxford rd", :telephone => "4534", :website => 'http://b.com', :description => 'I am '
  end

  let(:organizations) do
    [org1,org2]
  end

  before(:each) do
    assign(:organizations, organizations)
  end

  it "renders a search form" do
    render
    rendered.should have_selector "form input[name='q']"
    rendered.should have_selector "form input[type='submit']"
  end

  it "render organization names with hyperlinks" do
    render
    organizations.each do |org|
      rendered.should have_link org.name, :href => organization_path(org.id)
      rendered.should have_content org.description.truncate(24,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    render
    rendered.should_not have_content org1.address
    rendered.should_not have_content org1.telephone
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    render
    rendered.should_not have_link 'Edit'
    rendered.should_not have_link 'Destroy'
    rendered.should_not have_content org2.address
    rendered.should_not have_content org2.telephone
  end


    
end
