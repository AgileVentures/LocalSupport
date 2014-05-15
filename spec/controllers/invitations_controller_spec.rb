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
      params.keys.each do |key|
        params.delete(key)
        expect(->{post :create, params}).to raise_error KeyError, "key not found: \"#{key}\""
      end
    end

    it 'calls BatchInvite with the required args' do
      expect(BatchInvite).to receive(:call).with(
        UserInviter, params[:invite_list], controller.current_user, params[:resend_invitation]
      )
      post :create, params
    end

    it 'responds with json' do
      results = double :results
      allow(BatchInvite).to receive(:call) { results }
      expect(results).to receive(:to_json) { 'json stuff' }
      post :create, params
      expect(response.body).to eq 'json stuff'
    end
  end
end
