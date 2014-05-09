require 'spec_helper'

describe "Invitations" do
  describe "POST /invitations", :helpers => :requests do
    let(:non_admin) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:user, email: 'admin@example.com', admin: true) }
    let(:params) { {values: [{id: '3', email: 'what@ever.com'}], resend_invitation: false} }

    describe 'security' do
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

    describe 'emails' do
      let(:email) { ActionMailer::Base.deliveries.last }
      before(:each) do
        ActionMailer::Base.deliveries.clear
        login(admin)
        xhr :post, invitations_path, params
      end

      it 'attributes' do
        email.from.should eq ['support@harrowcn.org.uk']
        email.reply_to.should eq ['support@harrowcn.org.uk']
        email.to.should eq ['what@ever.com']
        email.cc.should eq ['technical@harrowcn.org.uk']
        email.subject.should eq 'Invitation to Harrow Community Network'
      end
    end

    describe 'association set between org and new user' do
      let(:orphan) { FactoryGirl.create :organization }
      let(:params) { {values: [{id: orphan.id, email: orphan.email}], resend_invitation: false} }

      before do
        Gmaps4rails.stub :geocode # necessary until stub-net is merged
        login(admin)
      end

      it 'new user created' do
        expect {
          xhr :post, invitations_path, params
        }.to change(User, :count).by(1)
      end

      it 'new user is associated with org' do
        xhr :post, invitations_path, params
        invitee = User.find_by_email(orphan.email)
        expect(invitee.organization).to eq orphan
      end

      it 'new user is found by scope "invited_not_accepted"' do
        expect(User.invited_not_accepted.length).to eq 0
        xhr :post, invitations_path, params
        expect(User.invited_not_accepted.length).to eq 1
      end

      it 'warning: emails are downcased' do
        email = 'CAPSARECOOL@EXAMPLE.COM'
        params[:values][0][:email] = email
        xhr :post, invitations_path, params
        expect(User.invited_not_accepted.first.email).to eq email.downcase
      end
    end
  end
end
