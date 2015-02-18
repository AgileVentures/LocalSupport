require 'rails_helper'

describe OrganisationReportsController, :type => :controller do
  let(:org) { double('Organisation') }
  let(:user) { double 'User' }
  let(:session) { mock_model User, superadmin?: true, decrement_invitation_limit!: nil }
  before(:each) { allow(controller).to receive(:current_user).and_return(session) }

  it 'is for superadmins only' do
    allow(session).to receive(:superadmin?).and_return(false)
    get :without_users_index
    expect(response).to redirect_to '/'
  end

  describe '#without_users_index' do
    it 'uses the invitation table layout' do
      get :without_users_index
      expect(response).to render_template 'layouts/invitation_table'
    end

    it 'assigns an instance variable' do
      allow(Organisation).to receive_message_chain(:not_null_email, :null_users, :without_matching_user_emails).and_return([org])
      get :without_users_index
      expect(assigns(:orphans)).to include org
    end
  end

end
