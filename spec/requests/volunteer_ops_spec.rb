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

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      expect {
        post volunteer_ops_path, params
      }.to change(VolunteerOp, :count).by(0)
    end
  end

  describe 'DELETE /volunteer_ops/:id' do
    it 'destroys the requested volunteer_op' do
      login(org_owner)
      op = FactoryGirl.create(:volunteer_op)
      expect {
        delete volunteer_op_path({id: op.id})
      }.to change(VolunteerOp, :count).by(-1)
    end

    it 'does not work for non-org-owners' do
      login(non_org_owner)
      op = FactoryGirl.create(:volunteer_op)
      expect {
        delete volunteer_op_path({id: op.id})
      }.to change(VolunteerOp, :count).by(0)
    end
  end

end
