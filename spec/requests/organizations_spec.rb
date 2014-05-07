require 'spec_helper'

describe "Organizations" do
  describe "GET /organizations" do
    it "works! (now write some real specs)" do
      Page.stub(:all).and_return []
      get organizations_path
    end
  end
end
