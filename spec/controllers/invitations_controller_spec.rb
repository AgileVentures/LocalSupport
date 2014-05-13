require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    let(:params) do
      {
        values: 'whatever',
        resend_invitation: 'whatever'
      }
    end
    let(:response) { double :response }

    before do
      make_current_user_admin
      allow(BatchInvite).to receive(:call) { response }
    end

    it 'raises an error if either of the param keys are missing' do
      params.keys.each do |key|
        params.delete(key)
        expect(->{post :create, params}).to raise_error KeyError, "key not found: \"#{key}\""
      end
    end

    it 'calls BatchInvite with the required args' do
      expect(BatchInvite).to receive(:call).with(
        UserInviter, params[:values], controller.current_user, params[:resend_invitation]
      )
      post :create, params
    end

    it 'responds to format json' do
      expect(response).to receive(:to_json)
      post :create, params.merge({ :format => :json })
    end
  end
end
