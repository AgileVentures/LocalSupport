require 'spec_helper'

describe 'VolunteerOps' do
  describe 'POST /volunteer_ops', :helpers => :requests do
    let(:org_owner) { FactoryGirl.create(:user_stubbed_organization) }
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      login(org_owner)
      expect {
        post volunteer_ops_path, params
      }.to change(VolunteerOp, :count).by(1)
    end
  end
  # TODO: Move to request spec
  # it 'destroys the requested volunteer_op' do
  #   volunteer_op = VolunteerOp.create! valid_attributes
  #   expect {
  #     delete :destroy, {:id => volunteer_op.to_param}, valid_session
  #   }.to change(VolunteerOp, :count).by(-1)
  # end

end
