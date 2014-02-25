require 'spec_helper'

describe OrganizationReportsController do
  let(:org) { double('Organization') }
  let(:user) { double 'User' }
  # whatever devise invitable is doing with my current user is breaking rspec mocks, need a real User
  let(:session) { mock_model User, admin?: true, decrement_invitation_limit!: nil }
  before(:each) { controller.stub(:current_user).and_return(session) }

  it 'is for admins only' do
    session.stub(:admin?).and_return(false)
    get :without_users_index
    response.should redirect_to '/'
    post :without_users_create
    response.should redirect_to '/'
  end

  describe '#without_users_index' do
    it 'assigns an instance variable' do
      Organization.stub_chain(:not_null_email, :null_users).and_return([org])
      get :without_users_index
      assigns(:orphans).should include org
    end
  end

  describe '#without_users_create' do
    let(:error) { double('ActiveModel::Errors') }
    let(:params) { { values: [{id: 1, email: 'a@org.org'}, {id: 3, email: 'c@org.org'}] } }
    before(:each) do
      request.accept = 'application/json'
      User.stub :find_by_email => nil
      User.stub :invite! => user
    end

    it 'adds an error if the email is already in use by another user' do
      post :without_users_create, params
      res = ActiveSupport::JSON.decode(response.body)
      res.should eq({'1' => 'Error: I-dentify target!', '3' => 'Error: I-dentify target!'})
    end

    it 'parses errors if there are any' do
      user.stub :errors => error
      error.stub :any? => true
      error.stub :full_messages
      error.stub_chain(:full_messages, :first).and_return('Ready to roll out!')
      post :without_users_create, params
      res = ActiveSupport::JSON.decode(response.body)
      res.should eq({'1' => 'Error: Ready to roll out!', '3' => 'Error: Ready to roll out!'})
    end

    it 'elicits the reset password token otherwise' do
      post :without_users_create, params
      res = ActiveSupport::JSON.decode(response.body)
      res.should eq({'1' => 'Invited!', '3' => 'Invited!'})
    end
  end
end
