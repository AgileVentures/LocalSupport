require 'rails_helper'

describe InvitationsController, :type => :controller, :helpers => :controllers do

  describe '#create' do
    let(:params) { {} }

    context 'when not signed in as an superadmin' do
      it 'you get redirected' do
        post :create, params
        expect(response).to redirect_to root_path
        make_current_user_nonsuperadmin
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context 'when signed in as an superadmin' do
      let(:results) { double :results }
      before { make_current_user_superadmin }

      it 'calls the BatchInviteJob with the required args' do
        params.merge!({'controller'=>'invitations', 'action'=>'create'})
        expect(::BatchInviteJob).to receive(:new).with(
          params, controller.current_user
        ).and_return(results)
        expect(results).to receive(:run)
        post :create, params
      end

      it 'responds with json' do
        allow(::BatchInviteJob).to receive(:new) { results }
        allow(results).to receive(:run) { results }
        expect(results).to receive(:to_json) { 'json stuff' }
        post :create, params
        expect(response.body).to eq 'json stuff'
      end

    end
  end
end
