require "rails_helper"

describe OrganisationsController, :type => :routing do
  describe "routing" do

    it "recognizes and generates #index" do
      expect({ :get => "/organisations" }).to route_to(:controller => "organisations", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/organisations/new" }).to route_to(:controller => "organisations", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/organisations/1" }).to route_to(:controller => "organisations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/organisations/1/edit" }).to route_to(:controller => "organisations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/organisations" }).to route_to(:controller => "organisations", :action => "create")
    end

    it "recognizes and generates #update" do
      expect({ :put => "/organisations/1" }).to route_to(:controller => "organisations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/organisations/1" }).to route_to(:controller => "organisations", :action => "destroy", :id => "1")
    end

  end
end
