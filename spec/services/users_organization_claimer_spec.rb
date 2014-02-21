require_relative '../../app/services/user_organization_claimer' 

describe UserOrganizationClaimer,'.call'  do 
  let(:listener) { double :listener } 
  let(:user) { double :user } 

  context 'an organization_id is set' do 
    let(:organization_id) { -1 } 
    let(:current_user) { double :current_user }
    let(:service) do 
      UserOrganizationClaimer.new(listener, user, current_user)
    end

    it 'update the pending organization id' do
      expect(user).to receive(:request_admin_status).with(organization_id)
      expect(listener).to receive(:update_message_for_admin_status)
      service.call(organization_id)
    end
  end

  context 'when current user is an admin and organization_id is not sent' do 
    let(:organization_id) { nil }
    let(:current_user) { double(:current_user, admin?:true) }
    let(:service) do 
      UserOrganizationClaimer.new(listener, user, current_user)
    end
    it 'promote the user to admin' do 
      expect(user).to receive(:promote_to_org_admin)
      expect(listener).to receive(:update_message_promoting).with(user)
      service.call(organization_id)
    end
  end
end
