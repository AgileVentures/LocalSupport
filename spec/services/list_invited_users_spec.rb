require_relative '../../app/services/list_invited_users'

describe ListInvitedUsers, '.list' do 
  let(:organization_class) { double :organization_class }
  let(:organization) do double(:organization, 
                              present?:true,
                              id:-1,
                              name:'org',
                              email:'mail')  
  end
  let(:users) { [double(:user, email:'email@email.com', invitation_sent_at:'date')] } 

  it 'returns all invited users' do 
    expect(organization_class).to receive(:find_by_email).with('email@email.com') { organization }
    invitations = ListInvitedUsers.list(users, organization_class)
    invitations.should include({ id: -1, name: 'org', email: 'mail', date: 'date' })
  end

  it "skips collections that don't have both a user and and organization" do
    expect(organization_class).to receive(:find_by_email).with('email@email.com') { organization }
    organization.stub :present? => false
    invitations = ListInvitedUsers.list(users, organization_class)
    invitations.should_not include nil
  end
end
