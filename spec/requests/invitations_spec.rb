require 'spec_helper'

describe "Invitations", :helpers => :requests do
  describe "create -- xhr POST /invitations" do
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }

    describe 'batch invites' do
      let(:org) { FactoryGirl.create :organization, email: 'yes@hello.com' }
      let(:params) do
        {invite_list: {org.id => org.email,
                       org.id+1 => org.email},
          resend_invitation: false}
      end

      before do
        Gmaps4rails.stub :geocode
        login(admin)
      end

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
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }

    describe "User.invited_not_accepted returns users w/o orgs" do
      let(:org) { FactoryGirl.create :organization, email: 'yes@hello.com' }
      let(:lost_invite) { User.invite!({email: org.email}, admin) }

      before do
        Gmaps4rails.stub :geocode
        login(admin)
      end

      it 'users w/o orgs will cause nil errors if not protected' do
        expect(lost_invite.organization).to be nil
        expect(User.invited_not_accepted).to include lost_invite
        expect { get invited_users_report_path }.to_not raise_error
      end
    end
  end
end
