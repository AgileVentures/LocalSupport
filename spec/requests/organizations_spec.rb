require 'spec_helper'

describe "Organisations" do
  describe "GET /organisations" do
    it "works! (now write some real specs)" do
      Page.stub(:all).and_return []
      get organisations_path
    end
  end
end
