require 'spec_helper'

describe OrphansController do
  let(:org) { double('Organization') }
  let(:user) { double('User') }
  let(:session) { double(:admin? => true) }
  before(:each) { controller.stub(:current_user).and_return(session) }

  it 'is for admins only' do
    session.stub(:admin?).and_return(false)
    get :index
    response.should redirect_to '/'
    post :create, {}
    response.should redirect_to '/'
  end

  describe '#index' do
  end

  describe '#create' do
    let(:error) { double('ActiveModel::Errors') }
    before(:each) do
      Organization.should_receive(:find_by_id).with('3').and_return(org)
      org.should_receive(:generate_potential_user).and_return(user)
    end

    it 'parses errors if there are any' do
      user.should_receive(:errors).twice.and_return(error)
      error.should_receive(:any?).and_return(true)
      error.should_receive(:full_messages)
      error.stub_chain(:full_messages, :first).and_return('just calling to say i love you')
    end

    it 'elicits the reset password token otherwise' do
      user.should_receive(:errors).once.and_return(error)
      error.should_receive(:any?).and_return(false)
      user.should_receive(:reset_password_token).and_return('just calling to say i love you')
    end

    after(:each) do
      post :create, { id: '3' }
      debugger
      request.accept = 'application/json'
      post :create, { id: '3' }
      ActiveSupport::JSON.decode(response.body).should eq('just calling to say i love you')
    end
  end
end