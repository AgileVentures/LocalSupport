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
    
    context "organization donation_info is not nil" do
      before(:each) do
       @organization = assign :organization,  stub_model(Organization, :name => 'Friendly charity', :donation_info => 'http://www.friendly-charity.co.uk/donate')
      end 
      it "should return the donation_info url" do
        donation_info_msg.should == link_to("Donate to #{@organization.name} now!", @organization.donation_info)
      end
    end


  end
end
