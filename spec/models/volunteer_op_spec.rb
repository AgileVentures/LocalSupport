require 'spec_helper'

describe VolunteerOp do
  it "is valid with valid attributes" do
    VolunteerOp.new(:title => "Title", :organization_id => "1").should be_valid
  end

  it "is not valid without an organization" do
    VolunteerOp.new(:title => "Title").should_not be_valid
  end


  it "is not valid without a title" do
    VolunteerOp.new(:organization_id => "1").should_not be_valid
  end
end
