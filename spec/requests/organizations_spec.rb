require 'spec_helper'

shared_examples_for 'a restricted API' do |actions|

  actions.each do |action, request|
    it "admin users can access #{action}" do
      login(admin)
      route = RequestHelpers::Routable.new(request, org)
      self.send(:request_via_redirect, route.verb, route.url)
      response.status.should be 200
      flash[:error].should be nil
    end
  end
end

describe "Organizations", :helpers => :requests do
  extend RequestHelpers

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

  it_should_behave_like 'a restricted API', actions do
    let(:org) { FactoryGirl.create :organization }
    # let(:non-admin) { FactoryGirl.create :user }
    let(:admin) { FactoryGirl.create :admin_user}
  end

end
