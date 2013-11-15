require 'spec_helper'

describe "organizations/show.html.erb" do

  let(:organization) do
    stub_model Organization, :address => "12 pinner rd", :telephone => "1234"
  end

  before(:each) do
    assign(:organization, organization)
    render
  end

  context "some information is private" do
    it "should not show telephone and address by default" do
      rendered.should_not have_content organization.address
      rendered.should_not have_content organization.telephone
    end
    
    it "should not show edit link by default" do
      rendered.should_not have_link 'Edit'
    end
  end

  context "has donation info url" do
    let(:organization) do
      stub_model Organization, :name => 'Friendly', :donation_info => 'http://www.friendly-charity.co.uk/donate'
    end

    it "renders donation info" do
      rendered.should have_selector 'a', :content => "Donate to #{organization.name} now!", :href => organization.donation_info, :target => '_blank'
    end
  end

  context "has website url" do
    let(:organization) do
      stub_model Organization, :website => 'http://www.friendly-charity.co.uk/'
    end

    it "renders website link" do
      rendered.should have_selector 'a', :content => "#{organization.website}", :href => organization.website, :target => '_blank'
    end
  end

  context "has no website url" do
    let(:organization) do
      stub_model Organization, :website => ''
    end
    it "renders no donation link" do
      rendered.should_not have_link "", :href => ""
    end
    it "renders no website text message" do
      rendered.should have_content "We don't yet have a website link for them"
    end
  end

  context "has no donation info url" do
    let(:organization) do
      stub_model Organization, :name => 'Charity with no donation URL'
    end
    it "renders no donation link" do
      rendered.should_not have_link "Donate to #{organization.name} now!", :href => organization.donation_info
    end
    it "renders no donation text message" do
      rendered.should have_content "We don't yet have any donation link for them."
    end
  end

  context 'edit button' do
    let(:organization) do
      stub_model Organization, :id => 1
    end
    it 'renders edit button if editable true' do
      @editable = assign(:editable, true)
      render
      rendered.should have_link "Edit", :href => edit_organization_path(organization.id)
    end
    it 'does not render edit button if editable false' do
      @editable = assign(:editable, false)
      render
      rendered.should_not have_link :href => edit_organization_path(organization.id)
    end
    it 'does not render edit button if editable nil' do
      @editable = assign(:editable, nil)
      render
      rendered.should_not have_link :href => edit_organization_path(organization.id)
    end
  end

  context 'delete button' do
    let(:organization) do
      stub_model Organization, :id => 1
    end
    it 'renders delete button if deletable true' do
      @deletable = assign(:deletable, true)
      render
      rendered.should have_button "Delete"
    end
    it 'does not render delete button if deletable false' do
      @deletable = assign(:deletable, false)
      render
      rendered.should_not have_button "Delete"
    end
    it 'does not render delete button if deletable nil' do
      @deletable = assign(:deletable, nil)
      render
      rendered.should_not have_button "Delete"
    end
  end
end
