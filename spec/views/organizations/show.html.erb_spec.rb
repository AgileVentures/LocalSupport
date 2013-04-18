require 'spec_helper'

describe "organizations/show.html.erb" do

  context "some information is private" do
    let(:organization) do
      stub_model Organization,:name => 'test', :address => "12 pinner rd", :telephone => "1234"
    end
    
    it "should not show telephone and address by default" do
      @organization = assign(:organization, organization)
      render
      rendered.should_not have_content @organization.address
      rendered.should_not have_content @organization.telephone
    end
    
  end

  context "has donation info url" do
    before(:each) do
      @organization = assign(:organization, stub_model(Organization, :name => 'Friendly charity', :donation_info => 'http://www.friendly-charity.co.uk/donate'))
    end
    it "renders attributes in <p>" do
      render
    end

    it "renders donation info" do
      render
      rendered.should have_link "Donate to #{@organization.name} now!", :href =>   @organization.donation_info
    end
  end

  context "has no donation info url" do
    before(:each) do
      @organization = assign(:organization, stub_model(Organization, :name => 'Charity with no donation URL'))
    end
    it "renders no donation link" do
      render
      rendered.should_not have_link "Donate to #{@organization.name} now!", :href => @organization.donation_info
    end
    it "renders no donation text message" do
      render
      rendered.should have_content "We don't yet have any donation link for them."
    end
  end
end
