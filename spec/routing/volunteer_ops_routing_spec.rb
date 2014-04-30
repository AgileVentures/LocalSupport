require "spec_helper"

describe VolunteerOpsController do
  describe "routing" do

    it "routes to #index" do
      get("/volunteer_ops").should route_to("volunteer_ops#index")
    end

    it "routes to #new" do
      get("/volunteer_ops/new").should route_to("volunteer_ops#new")
    end

    it "routes to #show" do
      get("/volunteer_ops/1").should route_to("volunteer_ops#show", :id => "1")
    end

    it "routes to #edit" do
      get("/volunteer_ops/1/edit").should route_to("volunteer_ops#edit", :id => "1")
    end

    it "routes to #create" do
      post("/volunteer_ops").should route_to("volunteer_ops#create")
    end

    it "routes to #update" do
      put("/volunteer_ops/1").should route_to("volunteer_ops#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/volunteer_ops/1").should route_to("volunteer_ops#destroy", :id => "1")
    end

  end
end
