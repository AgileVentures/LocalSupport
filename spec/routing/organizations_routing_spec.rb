require "spec_helper"

describe OrganisationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/organisations" }.should route_to(:controller => "organisations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/organisations/new" }.should route_to(:controller => "organisations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/organisations/1" }.should route_to(:controller => "organisations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/organisations/1/edit" }.should route_to(:controller => "organisations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/organisations" }.should route_to(:controller => "organisations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/organisations/1" }.should route_to(:controller => "organisations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/organisations/1" }.should route_to(:controller => "organisations", :action => "destroy", :id => "1")
    end

  end
end
