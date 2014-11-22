require "rails_helper"

describe PagesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/pages")).to route_to("pages#index")
    end

    it "routes to #new" do
      expect(get("/pages/new")).to route_to("pages#new")
    end

    it "routes to #show" do
      expect(get("/1")).to route_to("pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/pages/1/edit")).to route_to("pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/pages")).to route_to("pages#create")
    end

    it "routes to #update" do
      expect(patch("/1")).to route_to("pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/1")).to route_to("pages#destroy", :id => "1")
    end

  end
end
