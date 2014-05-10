require 'spec_helper'

describe "Access to the Organizations API", :helpers => [:requests, :route_collector] do
  extend RouteCollector

  actions = collect_actions_for(OrganizationsController)

  actions.slice(:create, :update).each do |action, _|
    actions[action].add_params(
        {
            :organization => {
                :name => 'hello',
                :description => 'world'
            }
        }
    )
  end


  let(:org) { FactoryGirl.create :organization }

  describe 'admin access' do
    let(:admin) { FactoryGirl.create :admin_user }
    before { login(admin) }

    actions.each do |action, request|
      it "admin users can access #{action}" do
        route = route_request_for(request, org)
        self.send(:request_via_redirect, route.verb, route.url)
      end
    end

    after do
      page_view.should_not have_content PERMISSION_DENIED
    end
  end

  describe 'regular user' do
    let(:user) { FactoryGirl.create :user }

    context 'associated with given org' do
      before do
        login(user)
        user.organization_id = org.id
        user.save!
      end

      actions.except(:create, :destroy).each do |action, request|
        it "regular users can access #{action} with their organization" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should_not have_content PERMISSION_DENIED
        end
      end

      actions.slice(:create, :destroy).each do |action, request|
        it "regular users cannot access #{action} with their organization" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should have_content PERMISSION_DENIED
        end
      end
    end

    context 'associated with some other org' do
      let(:org2) { FactoryGirl.create :organization, name: 'other org'}
      before do
        login(user)
        user.organization_id = org2.id
        user.save!
      end

      actions.except(:edit, :update, :create, :destroy).each do |action, request|
        it "regular users can access #{action} with some other organization" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should_not have_content PERMISSION_DENIED
        end
      end

      actions.slice(:edit, :update, :create, :destroy).each do |action, request|
        it "regular users cannot access #{action} with some other organization" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should have_content PERMISSION_DENIED
        end
      end
    end


    context 'not associated with any org' do
      before { login(user) }

      actions.except(:edit, :update, :create, :destroy).each do |action, request|
        it "regular users with no organization can access #{action}" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should_not have_content PERMISSION_DENIED
        end
      end

      actions.slice(:edit, :update, :create, :destroy).each do |action, request|
        it "regular users with no organization cannot access #{action}" do
          route = route_request_for(request, org)
          self.send(:request_via_redirect, route.verb, route.url)
          page_view.should have_content PERMISSION_DENIED
        end
      end
    end
  end

  describe 'no user signed in' do
    actions.slice(:search, :index, :show).each do |action, request|
      it "public users can access #{action}" do
        route = route_request_for(request, org)
        self.send(:request_via_redirect, route.verb, route.url)
        page_view.should_not have_content PERMISSION_DENIED
        page_view.should_not have_content 'You need to sign in or sign up before continuing.'
      end
    end

    actions.except(:search, :index, :show).each do |action, request|
      it "public users cannot access #{action}" do
        route = route_request_for(request, org)
        self.send(:request_via_redirect, route.verb, route.url)
        page_view.should have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end


  def page_view
    Capybara::Node::Simple.new(@response.body)
  end
end
