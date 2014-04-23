require 'spec_helper'

describe VolunteerOpsController do
  let(:op) { double :volunteer_op }

  describe 'GET index' do
    it 'assigns all volunteer_ops as @volunteer_ops' do
      VolunteerOp.should_receive(:all) { [op] }
      get :index, {}
      assigns(:volunteer_ops).should eq [op]
    end
  end
end