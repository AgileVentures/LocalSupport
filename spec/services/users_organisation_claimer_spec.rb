require_relative '../../app/services/user_organisation_claimer' 

describe UserOrganisationClaimer,'.call'  do 
  let(:listener) { double :listener } 
  let(:user) { double :user } 

  context 'an organisation_id is set' do 
    let(:organisation_id) { -1 } 
    let(:current_user) { double(:current_user, superadmin?:false) }
    let(:service) do 
      UserOrganisationClaimer.new(listener, user, current_user)
    end

    it 'update the pending organisation id' do
      expect(user).to receive(:request_admin_status).with(organisation_id)
      expect(listener).to receive(:update_message_for_admin_status)
      service.call(organisation_id)
    end
  end

  context 'when current user is an superadmin and organisation_id is not sent' do 
    let(:organisation_id) { nil }
    let(:current_user) { double(:current_user, superadmin?:true) }
    let(:service) do 
      UserOrganisationClaimer.new(listener, user, current_user)
    end
    it 'promote the user to superadmin' do 
      expect(user).to receive(:promote_to_org_admin)
      expect(listener).to receive(:update_message_promoting).with(user)
      service.call(organisation_id)
    end
  end
end
