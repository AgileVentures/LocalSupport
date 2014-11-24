require "rails_helper"

describe VolunteerOpsController, :type => :routing do
  describe "routing" do
    before :each do
      allow(Feature).to receive(:active?).with(:volunteer_ops).and_return(true)
    end

    it "routes to #index" do
      expect(get("/volunteer_ops")).to route_to("volunteer_ops#index")
    end

    it "routes to #new" do
      expect(get("/organisations/2/volunteer_ops/new")).to route_to("volunteer_ops#new", organisation_id: "2")
    end

    it "routes to #show" do
      expect(get("/volunteer_ops/1")).to route_to("volunteer_ops#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/volunteer_ops/1/edit")).to route_to("volunteer_ops#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/organisations/2/volunteer_ops")).to route_to("volunteer_ops#create", organisation_id: "2")
    end

    it "routes to #update" do
      expect(put("/volunteer_ops/1")).to route_to("volunteer_ops#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/volunteer_ops/1")).to route_to("volunteer_ops#destroy", :id => "1")
    end
  end
end
