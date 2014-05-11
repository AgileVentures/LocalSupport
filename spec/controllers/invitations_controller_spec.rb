require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    let(:job) { double :batch_invite }
    let(:params) do
      {
        values: [{'id' =>  '-1', 'email' => 'org@email.com'}],
        resend_invitation: 'false'
      }
    end

    before do
      make_current_user_admin
      allow(Devise).to receive(:resend_invitation=)
      allow(BatchInvite).to receive(:new) { job }
      allow(job).to receive(:run) { job }
    end

    it 'tells Devise about the resend_invitation flag' do
      expect(Devise).to receive(:resend_invitation=).with(false)
      post :create, params
    end

    it 'initializes the job with the variables needed to invite users to orgs' do
      expect(BatchInvite).to receive(:new).with(
        User, Organization, :organization_id=, controller.current_user
      ) { job }
      post :create, params
    end

    it 'runs the job with the invite list' do
      expect(job).to receive(:run).with(params[:values]) { job }
      post :create, params
    end

    it 'responds to format json' do
      expect(job).to receive(:to_json)
      post :create, params.merge({ :format => :json })
    end
  end
end
