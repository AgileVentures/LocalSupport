require 'spec_helper'

describe 'VolunteerOps', :helpers => :requests do
  let(:org_owner) { FactoryGirl.create(:user_stubbed_organisation) }
  let(:non_org_owner) { FactoryGirl.create :user }

  describe 'POST /volunteer_ops' do
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      org_admin = org_owner
      login(org_admin)
      expect {
        post organisation_volunteer_ops_path(org_admin.organisation), params
      }.to change(VolunteerOp, :count).by(1)
    end

    it 'the new VolunteerOp is associated with the organisation of the current user' do
      org_admin = org_owner
      login(org_admin)
      post organisation_volunteer_ops_path(org_admin.organisation), params
      op = VolunteerOp.last
      op.organisation.should eq org_admin.organisation
    end

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      expect {
        post organisation_volunteer_ops_path(4), params
      }.to change(VolunteerOp, :count).by(0)
    end
  end
end
