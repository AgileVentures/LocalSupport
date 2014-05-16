require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    let(:params) { {} }

    context 'when not signed in as an admin' do
      it 'you get redirected' do
        post :create, params
        expect(response).to redirect_to root_path
        make_current_user_nonadmin
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context 'when signed in as an admin' do
      before { make_current_user_admin }

      it 'calls the Invitations service with the required args' do
        params.merge!({'controller'=>'invitations', 'action'=>'create'})
        expect(::Invitations).to receive(:call).with(params, controller.current_user)
        post :create, params
      end

      it 'responds with json' do
        results = double :results
        allow(::Invitations).to receive(:call) { results }
        expect(results).to receive(:to_json) { 'json stuff' }
        post :create, params
        expect(response.body).to eq 'json stuff'
      end

    end
  end
end
