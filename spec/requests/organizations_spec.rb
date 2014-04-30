require 'spec_helper'

shared_examples_for 'a restricted API' do |restricted|

  restricted.each do |action, route|
    it "admin users can access #{action}" do
      login(admin)
      route = RequestHelpers::Routable.new(org, route)
      self.send(:request_via_redirect, route.verb, route.url)
      response.status.should be 200
      flash[:error].should be nil
    end
  end
end

describe "Organizations", :helpers => :requests do
  extend RequestHelpers

  routes = RequestHelpers::RouteInspector.new(OrganizationsController)
  debugger
  thing = routes.only(:create)
  debugger

  routes.only(:create, :update).add_param(
    {:organization => {:name => 'hello', :description => 'world'}}
  )

  # [:create, :update].each do |action|
  #   inspected.routes[action][:organization] = {}
  # end
  #
  # # routes.only(:create, :update).each do |route|
  # #   r
  # # end
  #
  # routes = RequestHelpers::RouteFinder.new(OrganizationsController)
  # routes.add_param({:organization => {:name => 'hello'}}, [:create, :update])
  # restricted = routes.find(:only => [:new, :create, :edit, :update, :destroy])
  #
  # # it 'routes' do
  # #   puts 'hi'
  # #   debugger
  # #   puts 'lo'
  # # end

  it_should_behave_like 'a restricted API', restricted do
    let(:org) { FactoryGirl.create :organization }
    # let(:non-admin) { FactoryGirl.create :user }
    let(:admin) { FactoryGirl.create :admin_user}
  end

end
