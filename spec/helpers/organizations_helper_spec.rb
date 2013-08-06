require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the OrganizationsHelper. For example:
#
# describe OrganizationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe OrganizationsHelper do
  
  describe "donation_info_msg" do

    context "organization donation_info is nil" do
      before(:each) do
        @organization = assign :organization,  stub_model(Organization, :name => 'Friendly charity', :donation_info => nil)
      end
      it "should return no donation info message" do
        donation_info_msg.should == "We don't yet have any donation link for them."
      end
    end

    context "organization donation_info is empty string" do
      before(:each) do
        @organization = assign :organization,  stub_model(Organization, :name => 'Friendly charity', :donation_info => "")
      end
      it "should return no donation info message" do
        donation_info_msg.should == "We don't yet have any donation link for them."
      end
    end

    context "organization donation_info is not nil" do
      before(:each) do
       @organization = assign :organization,  stub_model(Organization, :name => 'Friendly charity', :donation_info => 'http://www.friendly-charity.co.uk/donate')
      end 
      it "should return the donation_info url" do
        donation_info_msg.should == link_to("Donate to #{@organization.name} now!", @organization.donation_info, {:target => '_blank'})
      end
    end


  end

  describe "charity admin display helper" do
    context "organization has no admins" do
      before(:each) do
        @organization = assign :organization, stub_model(Organization)
        @organization.stub :users => []
      end
      it 'should return a no current admins message' do
         expect(charity_admin_display_msg).to have_selector "div", :content => "This organization has no admins yet"
      end
    end
    context "organization has one admin" do
      before(:each) do
        @organization = assign :organization, stub_model(Organization)
        user = stub_model(User)
        user.stub(:email => "blah@blah.com")
        @organization.stub(:users => [user])
      end
      it 'should return the list of admins' do
        result = charity_admin_display_msg
        expect(result).to have_content "Organization administrator emails: "
        expect(result).to have_selector "ol"
        expect(result).to have_selector "li", :content => @organization.users.first.email
      end
    end
  end
end
