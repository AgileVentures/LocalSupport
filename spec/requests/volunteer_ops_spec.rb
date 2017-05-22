require 'rails_helper'

describe 'VolunteerOps', :type => :request, :helpers => :requests do
  let(:org_owner) { FactoryGirl.create(:user_stubbed_organisation) }
  let(:non_org_owner) { FactoryGirl.create :user , :email => 'regularjoe@blah.com'}
  let(:superadmin) {FactoryGirl.create :user, :email => "superadmin@superadmin.com", :superadmin => true}

  describe 'POST /volunteer_ops' do
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      org_admin = org_owner
      login(org_admin)
      expect {
        post organisation_volunteer_ops_path(org_admin.organisation), params
      }.to change(VolunteerOp, :count).by(1)
    end

    it 'the new VolunteerOp is associated with the requested organisation' do
      org_admin = org_owner
      login(org_admin)
      post organisation_volunteer_ops_path(org_admin.organisation), params
      op = VolunteerOp.last
      expect(op.organisation).to eq org_admin.organisation
    end

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      expect {
        post organisation_volunteer_ops_path(org_owner.organisation.id), params
      }.to change(VolunteerOp, :count).by(0)
    end

    it 'does work for superadmins' do
      login(superadmin)
      expect{
        post organisation_volunteer_ops_path(org_owner.organisation.id), params
      }.to change(VolunteerOp, :count).by(1)
    end
  end
end
