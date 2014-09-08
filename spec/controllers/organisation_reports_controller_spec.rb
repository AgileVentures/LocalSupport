require 'spec_helper'

describe OrganisationReportsController do
  let(:org) { double('Organisation') }
  let(:user) { double 'User' }
  let(:session) { mock_model User, admin?: true, decrement_invitation_limit!: nil }
  before(:each) { controller.stub(:current_user).and_return(session) }

  it 'is for admins only' do
    session.stub(:admin?).and_return(false)
    get :without_users_index
    response.should redirect_to '/'
  end

  describe '#without_users_index' do
    it 'uses the invitation table layout' do
      get :without_users_index
      response.should render_template 'layouts/invitation_table'
    end

    it 'assigns an instance variable' do
      Organisation.stub_chain(:not_null_email, :null_users, :without_matching_user_emails).and_return([org])
      get :without_users_index
      assigns(:orphans).should include org
    end
  end

end
