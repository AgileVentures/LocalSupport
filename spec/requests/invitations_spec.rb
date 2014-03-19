require 'spec_helper'

describe "Invitations" do
  describe "POST /invitations", :helpers => :requests do
    let(:non_admin) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }
    let(:params) { { values: [{ id: '3', email: 'what@ever.com' }], resend_invitation: false } }

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
end