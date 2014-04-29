require 'spec_helper'

shared_examples_for 'a restricted API' do |restricted|
  # debugger
  restricted.each_pair do |action, route|
    it "#{action} is restricted" do
      login(admin)
      route = RequestHelpers::Routable.new(org, route)
      # debugger
      self.send(:request_via_redirect, route.verb, route.url)
      # eval("request_via_redirect(:#{route.verb}, '#{route.url}')")
      response.status.should be 200
      flash[:error].should be nil
    end
  end
end

describe "Organizations", :helpers => :requests do
  extend RequestHelpers

  # debugger

  routes = RequestHelpers::RouteFinder.new(OrganizationsController)
  routes.add_param({:organization => {:name => 'hello'}}, [:create, :update])
  restricted = routes.find(:only => [:new, :create, :edit, :update, :destroy])

  # it 'routes' do
  #   puts 'hi'
  #   debugger
  #   puts 'lo'
  # end

  it_should_behave_like 'a restricted API', restricted do
    let(:org) { FactoryGirl.create :organization }
    # let(:non-admin) { FactoryGirl.create :user }
    let(:admin) { FactoryGirl.create :admin_user}
  end

end
