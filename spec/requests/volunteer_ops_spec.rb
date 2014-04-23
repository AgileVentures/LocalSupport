require 'spec_helper'

describe 'VolunteerOps', :helpers => :requests do
  let(:org_owner) { FactoryGirl.create(:user_stubbed_organization) }
  let(:non_org_owner) { FactoryGirl.create :user }

  describe 'POST /volunteer_ops' do
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      login(org_owner)
      expect {
        post volunteer_ops_path, params
      }.to change(VolunteerOp, :count).by(1)
    end

    it 'the new VolunteerOp is associated with the organization of the current user' do
      login(org_owner)
      post volunteer_ops_path, params
      op = VolunteerOp.last
      op.organization.should eq org_owner.organization
    end

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      expect {
        post volunteer_ops_path, params
      }.to change(VolunteerOp, :count).by(0)
    end
  end
end
