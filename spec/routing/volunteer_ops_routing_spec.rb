require "spec_helper"

describe VolunteerOpsController do
  describe "routing" do
    context 'feature flag enabled' do
      before :each do
        Feature.stub(:active?).with(:volunteer_ops).and_return(true)
      end

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

  context 'feature flag disabled' do
    before(:each) do
      Feature.create!(name: 'volunteer_ops', active: false)
    end

    it "does not route to #index" do
      # This is the only way of testing this route because of the way
      # the pages routing is set up. This will always raise a
      # ActiveRecord::RecordNotFound error unless their is a static page
      # with the permalink "volunteer_ops".
      expect(get("/volunteer_ops")).to route_to(
                                           :controller => "pages",
                                           :action => "show",
                                           :id => "volunteer_ops"
                                       )
    end

    it "does not route to #new" do
      get("/volunteer_ops/new").should_not be_routable
    end

    it "does not route to #show" do
      get("/volunteer_ops/1").should_not be_routable
    end

    it "does not route to #edit" do
      get("/volunteer_ops/1/edit").should_not be_routable
    end

    it "does not route to #create" do
      post("/volunteer_ops").should_not be_routable
    end

    it "does not route to #update" do
      put("/volunteer_ops/1").should_not be_routable
    end

    it "does not route to #destroy" do
      delete("/volunteer_ops/1").should_not be_routable
    end
  end
end
