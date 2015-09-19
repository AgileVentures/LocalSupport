require 'rails_helper'

describe ProposedOrganisationsController do
  describe 'GET show' do
    before do
      user = double(:user, superadmin: 'you bet!')
      controller.stub(:current_user) { user }
    end
    let!(:proposed_org) { create(:proposed_organisation) }

    it 'assigns the requested volunteer_op as @volunteer_op' do
      get :show, id: proposed_org.id
      expect(assigns(:proposed_organisation)).to eq proposed_org
    end

    it 'assigns @markers' do
      create_list(:organisation, 2)
      create(:proposed_organisation)
      get :show, id: proposed_org.id
      expect(
        JSON.parse(assigns(:markers))
      ).to match(a_collection_containing_exactly(an_instance_of(Hash)))
    end
  end
end
