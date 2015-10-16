require 'rails_helper'

describe "Moderate a proposed org", :type => :request, :helpers => :requests do
  let(:nonsuperadmin) { FactoryGirl.create(:user, superadmin: false) }
  let!(:proposed_org){FactoryGirl.create(:proposed_organisation)}

  context 'as non-superadmin' do
    before { login(nonsuperadmin) }

    it 'does not act upon non superadmins requests to accept org' do
      expect{patch(proposed_organisation_path(proposed_org))}.not_to change(ProposedOrganisation, :count)
    end

    it 'does not act upon non superadmins requests to decline/destroy org' do
      expect{delete(proposed_organisation_path(proposed_org))}.not_to change(ProposedOrganisation, :count)
    end

    it 'does not show proposed org' do
      get proposed_organisation_path(proposed_org)
      expect(response).to redirect_to root_path
    end

  end

  context 'as anonymous user' do
    it 'does not show proposed org' do
      get proposed_organisation_path(proposed_org)
      expect(response).to redirect_to root_path
    end
  end
end
