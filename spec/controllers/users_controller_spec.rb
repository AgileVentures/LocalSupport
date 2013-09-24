require 'spec_helper'

describe UsersController do
  before :all do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "index" do

    it '' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
  end
end
