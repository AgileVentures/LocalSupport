require 'spec_helper'

describe "Invitations" do
  describe "create -- xhr POST /invitations", :helpers => :requests do
    let(:non_admin) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }

    describe 'security' do
      let(:params) { {invite_list: [{id: '3', email: 'what@ever.com'}], resend_invitation: false} }

      it 'un-signed-in users not allowed' do
        xhr :post, invitations_path, params
        expect(response.code).to eq('302')
      end
      it 'non-admins not allowed' do
        login(non_admin)
        xhr :post, invitations_path, params
        expect(response.code).to eq('302')
      end
      it 'admins allowed' do
        login(admin)
        xhr :post, invitations_path, params
        expect(response.code).to eq('200')
      end
    end

    describe 'batch invites' do
      let(:org) { FactoryGirl.create :organization, email: 'yes@hello.com' }
      let(:params) do
        {invite_list: [
            {id: org.id, email: org.email },
            {id: org.id+1, email: org.email }
          ],
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
