require 'spec_helper'

describe "Invitations" do
  describe "create -- xhr POST /invitations", :helpers => :requests do
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }

    describe 'batch invites' do
      let(:org) { FactoryGirl.create :organization, email: 'yes@hello.com' }
      let(:params) do
        {invite_list:
          {org.id => org.email,
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
end
