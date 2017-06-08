require "rails_helper"

describe EventsController, type: :controller do

  before(:all) do
    FactoryGirl.create_list(:event, 10)
  end

  describe "#index" do

    it "should return a valid request" do
      get :index
      expect(response.status).to eq 200
    end

    it "should assign an events variable" do
      get :index
      expect(assigns(:events)).to all be_a_kind_of Event
    end

  end

end
