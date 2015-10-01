require 'rails_helper'

describe InviteUnregisteredUserFromProposedOrg do

  context 'successful invite' do

    let(:unregistered_email){"unregistered@email.com"}
    let(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation)}
    let(:subject){InviteUnregisteredUserFromProposedOrg.new(unregistered_email,proposed_org).run}

    it 'sends an email' do
      expect(->{subject}).to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'creates a user' do
      expect(->{subject}).to change(User, :count).by(1)
      expect(User.find_by(email: unregistered_email)).not_to be_nil
    end

    it 'associates user with the proposed organisations' do
      subject
      expect(proposed_org.reload.users).to include(User.find_by(email: unregistered_email))
    end

  end

end
