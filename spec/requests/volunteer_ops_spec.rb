require 'spec_helper'

describe 'VolunteerOps', :helpers => :requests do
  let(:org_owner) { FactoryGirl.create(:user_stubbed_organization) }
  before do
    login(org_owner)
  end 

  describe 'POST /volunteer_ops' do
    let(:params) { { volunteer_op: {title: 'hard work', description: 'for the willing'} } }

    it 'creates a new VolunteerOp' do
      expect {
        post volunteer_ops_path, params
      }.to change(VolunteerOp, :count).by(1)
    end
  end

  describe 'DELETE /volunteer_ops/:id' do
    # let(:op) { FactoryGirl.create(:volunteer_op) }

    it 'destroys the requested volunteer_op' do
      FactoryGirl.create(:volunteer_op)
      op_id = VolunteerOp.first.id
      puts "d"
      debugger
      # volunteer_op = VolunteerOp.create! valid_attributes
      expect {
        delete volunteer_ops_path({id: op_id})
      }.to change(VolunteerOp, :count).by(-1)
    end
  end

end
