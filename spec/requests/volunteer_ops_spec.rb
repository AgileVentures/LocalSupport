require 'rails_helper'

describe 'VolunteerOps', type: :request, helpers: :requests do
  let(:org_owner) { FactoryBot.create(:user_stubbed_organisation) }
  let(:non_org_owner) { FactoryBot.create :user , email: 'regularjoe@blah.com'}
  let(:superadmin) do
    FactoryBot.create :user,
                      email: 'superadmin@superadmin.com',
                      superadmin: true
  end

  describe 'POST /volunteer_ops' do
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      expect_any_instance_of(TwitterApi).to receive(:tweet).once
      org_admin = org_owner
      login(org_admin)
      expect do
        post organisation_volunteer_ops_path(org_admin.organisation), params: params
      end.to change(VolunteerOp, :count).by(1)
    end

    it 'the new VolunteerOp is associated with the requested organisation' do
      expect_any_instance_of(TwitterApi).to receive(:tweet).once
      org_admin = org_owner
      login(org_admin)
      post organisation_volunteer_ops_path(org_admin.organisation), params: params
      op = VolunteerOp.last
      expect(op.organisation).to eq org_admin.organisation
    end

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      expect do
        post organisation_volunteer_ops_path(org_owner.organisation.id), params: params
      end.to change(VolunteerOp, :count).by(0)
    end

    it 'does work for superadmins' do
      expect_any_instance_of(TwitterApi).to receive(:tweet).once
      login(superadmin)
      expect do
        post organisation_volunteer_ops_path(org_owner.organisation.id), params: params
      end.to change(VolunteerOp, :count).by(1)
    end
  end
end
