require "rails_helper"

describe EventsController, type: :controller do

  before(:all) do
    FactoryBot.create_list(:event, 10)
  end

  describe "#index" do

    setup do
      get :index
    end

    it { should render_template :index }

    it { should respond_with 200 }

    describe "@events variable" do

      it "should assign an events variable" do
        get :index
        expect(assigns(:events)).to all be_a_kind_of Event
      end

    end

  end

end
