require 'rails_helper'

describe "Invitations", :type => :request, :helpers => :requests do

  before do
    FactoryGirl.create :invitation_instructions
  end

  describe "create -- xhr POST /invitations" do
    let(:superadmin) { FactoryGirl.create(:user, email: 'superadmin@example.com', superadmin: true) }

    describe 'batch invites' do
      let(:org) { FactoryGirl.create :organisation, email: 'yes@hello.com' }
      let(:params) do
        {invite_list: {org.id => org.email,
                       org.id+1 => org.email},
          resend_invitation: false}
      end

      before { login(superadmin) }

      it 'example response for invites with duplicates' do
        xhr :post, invitations_path, params
        expect(JSON.parse(response.body)).to eq(
          {org.id.to_s => 'Invited!',
           (org.id+1).to_s => 'Error: Email has already been taken'}
        )
      end
    end
  end

  describe '#invited -- GET /user_reports/invited' do
    let(:superadmin) { FactoryGirl.create(:user, email: 'superadmin@example.com', superadmin: true) }

    describe "User.invited_not_accepted returns users w/o orgs" do
      let(:org) { FactoryGirl.create :organisation, email: 'yes@hello.com' }
      let(:lost_invite) { User.invite!({email: org.email}, superadmin) }

      before do
        login(superadmin)
      end

      it 'users w/o orgs will cause nil errors if not protected' do
        expect(lost_invite.organisation).to be nil
        expect(User.invited_not_accepted).to include lost_invite
        expect { get invited_users_report_path }.to_not raise_error
      end
    end
  end
end
