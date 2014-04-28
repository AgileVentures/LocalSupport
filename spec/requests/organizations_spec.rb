require 'spec_helper'

shared_examples_for 'a restricted API' do
  @restricted.each do |route|
    it '#{route[:action]} is restricted' do
      eval("request_via_redirect(:#{route[:verb]}, '#{route[:url]}')")
    end
  end
  @unrestricted.each do |route|
    it "#{route[:action]} is not restricted" do
      eval("request_via_redirect(:#{route[:verb]}, '#{route[:url]}')")
    end
  end
end

describe "Organizations", :helpers => :requests do
  let(:org) { FactoryGirl.create :organization }

  before do
    routes = RouteFinder.new(OrganizationsController)
    routes.add_matcher({:id => org.id}, [:create, :show, :edit, :update, :destroy])
    routes.make_urls
    # routes.add_params({:organization => attributes_for(:organization)}, [:create, :update])
    @unrestricted = routes.find(:only => [:search, :index, :show])
    @restricted = routes.find(:only => [:new, :create, :edit, :update, :destroy])
  end

  # it 'routes' do
  #   puts 'hi'
  #   debugger
  #   puts 'lo'
  # end

  it_behaves_like 'a restricted API'

end
