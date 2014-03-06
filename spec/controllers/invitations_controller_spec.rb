require 'spec_helper'

describe InvitationsController do
  let(:org) { double('Organization') }
  let(:user) { double 'User' }
  let(:session) { mock_model User, admin?: true, decrement_invitation_limit!: nil }
  before(:each) { controller.stub(:current_user).and_return(session) }

  describe '#create' do
    it 'is for admins only' do
      request.accept = 'application/json'
      #session.stub(:admin?).and_return(false)
      post :create, {
          :values => [{id: '1', email: 'no_owner@org.org'}, {id: '2', email: 'no_owner@org.org'}],
          :resend_invitation => false
      }
      response.should redirect_to '/'
    end
    #it '' do
    #  post :create
    #end
  end
end