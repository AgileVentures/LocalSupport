require 'rails_helper'

describe InviteUnregisteredUserFromProposedOrg do
  let(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation).accept_proposal}
  context 'successful invite' do

    let(:unregistered_email){"unregistered@email.com"}
    let(:subject){InviteUnregisteredUserFromProposedOrg.new(unregistered_email,proposed_org).run}

    it 'sends an email' do
      expect(->{subject}).to change{ActionMailer::Base.deliveries.size}.by(1)
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

  context 'invalid email' do

    let(:invalid_email){'xyz'}
    let(:subject){InviteUnregisteredUserFromProposedOrg.new(invalid_email,proposed_org).run}

    it 'has #error_message' do
      expect(subject).to respond_to :error_message
    end
    it 'does not send an email' do
      expect(->{subject}).not_to change{ActionMailer::Base.deliveries.size}
    end

    it 'returns non successful response object' do
      expect(subject).not_to be_success
    end

    it 'returns invalid email error code' do
      expect(subject.status).to eq InviteUnregisteredUserFromProposedOrg::Response::INVALID_EMAIL
    end

  end

  context 'no email' do
    let(:empty_email){""}
    let(:subject){InviteUnregisteredUserFromProposedOrg.new(empty_email,proposed_org).run}

    it 'returns non successful response object' do
      expect(subject).not_to be_success
    end

    it 'returns no email error code' do
      expect(subject.status).to eq InviteUnregisteredUserFromProposedOrg::Response::NO_EMAIL
    end
  end
end
