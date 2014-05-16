require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    let(:params) do
      {
        resend_invitation: 'whatever',
        invite_list: 'whatever',
      }
    end

    before do
      make_current_user_admin
    end

    it 'raises an error if either of the param keys are missing' do
      [:resend_invitation, :invite_list].each do |key|
        less_params = params.clone
        less_params.delete(key)
        expect(->{post :create, less_params}).to raise_error KeyError, "key not found: \"#{key}\""
      end
    end

    it 'calls BatchInviteJob with the required args' do
      expect(::Invitations::BatchInviteJob).to receive(:call).with(
        params[:resend_invitation], params[:invite_list], controller.current_user
      )
      post :create, params
    end

    it 'responds with json' do
      results = double :results
      allow(::Invitations::BatchInviteJob).to receive(:call) { results }
      expect(results).to receive(:to_json) { 'json stuff' }
      post :create, params
      expect(response.body).to eq 'json stuff'
    end
  end
end
