require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    # let(:current_user) { make_current_user_admin }
    # let(:inviter) { double :inviter }
    # let(:params) { {values: [{id:  '-1', email: 'org@email.com'}], resend_invitation: 'false'} }
    # let(:job) { double :BatchInvite }
    # 
    # before do
    #   Devise.stub(:resend_invitation=)
    #   BatchInvite.stub(:new) { job }
    #   job.stub(:run) { job }
    # end

    it 'test' do
      post :create, {}, { :format => :json }
    end
    it 'tells Devise about the resend_invitation flag' do
      expect(Devise).to receive(:resend_invitation=).with(params[:resend_invitation])
      post :create, params
    end

    it 'collects responses from the invitation process' do
      expect(BatchInvite).to receive(:new).with(User, Organization, current_user) { job }
      expect(job).to receive(:run).with(params[:values]) { batch }
    end

    it 'responds to format json' do
      expect(job).to receive(:to_json)
      post :create, params, { :format => :json }
    end
  end
end
