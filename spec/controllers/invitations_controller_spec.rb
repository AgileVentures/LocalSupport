require 'spec_helper'

describe InvitationsController, :helpers => :controllers do

  describe '#create' do
    let(:current_user) { make_current_user_admin }
    let(:inviter) { double :inviter }
    let(:params) { {values: [{id:  '-1', email: 'org@email.com'}], resend_invitation: false} }

    it 'collects responses from the invitation process' do
      expect(Inviter).to receive(:new).with(User, Devise, false) { inviter }
      expect(inviter).to receive(:rsvp).with('org@email.com', current_user, '-1') { 'a message' }
      post :create, params
      expect(assigns(:response)).to eq({'-1' => 'a message'})
    end
  end
end