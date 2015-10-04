require 'rails_helper'

describe  AcceptProposedOrganisation do
  let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: email)}
  let(:subject){AcceptProposedOrganisation.new(proposed_org).run}
  context 'proposed organisation email is not registered' do
    let(:email){"user@email.com"}

    it 'creates a user' do
      expect(->{subject}).to change(User, :count).by 1
    end

    it 'associates the user with the organisation' do
      subject
      expect(User.find_by(email: email).organisation).to eq Organisation.find(proposed_org.id)
    end

    it 'promotes the proposed org to org' do
      expect(->{subject}).to change(Organisation, :count).by 1
    end

    it 'has one less proposed organisation' do
      expect(->{subject}).to change(ProposedOrganisation, :count).by -1
    end

    it 'sends an email' do
      expect(->{subject}).to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    it 'returns an invitation sent result' do
      expect(subject.status).to eq(AcceptProposedOrganisation::Response::INVITATION_SENT)
    end

    it 'returns the accepted org on the result' do 
      expect(subject.accepted_organisation).to eq Organisation.find_by(name: proposed_org.name)
    end
  end

  context 'proposed organisation email is a registered user' do
    let(:email){"user@email.com"}
    let!(:user){FactoryGirl.create(:user, email: email)}

    it 'associates the user with the organisation' do
      subject
      expect(User.find_by(email: user.email).organisation).to eq Organisation.find(proposed_org.id)
    end

    it 'promotes the proposed org to org' do
      expect(->{subject}).to change(Organisation, :count).by 1
    end

    it 'has one less proposed organisation' do
      expect(->{subject}).to change(ProposedOrganisation, :count).by -1
    end

    it 'sends an email' do
      expect(->{subject}).to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    it 'returns a notification sent result' do
      expect(subject.status).to eq(AcceptProposedOrganisation::Response::NOTIFICATION_SENT)
    end

    it 'returns the accepted org on the result' do 
      expect(subject.accepted_organisation).to eq Organisation.find_by(name: proposed_org.name)
    end

  end

  context 'proposed organisation has no email' do
    let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: "")}

    it 'promotes the proposed org to org' do
      expect(->{subject}).to change(Organisation, :count).by 1
    end

    it 'has one less proposed organisation' do
      expect(->{subject}).to change(ProposedOrganisation, :count).by -1
    end

    it 'does not send an email' do
      expect(->{subject}).not_to change{ActionMailer::Base.deliveries.size}
    end

    it 'returns a notification sent result' do
      expect(subject.status).to eq(AcceptProposedOrganisation::Response::NO_EMAIL)
    end

    it 'returns the accepted org on the result' do 
      expect(subject.accepted_organisation).to eq Organisation.find_by(name: proposed_org.name)
    end

  end

  context 'proposed organisation has invalid email' do
    let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: "invalidemail.com")}

    it 'promotes the proposed org to org' do
      expect(->{subject}).to change(Organisation, :count).by 1
    end

    it 'has one less proposed organisation' do
      expect(->{subject}).to change(ProposedOrganisation, :count).by -1
    end

    it 'does not send an email' do
      expect(->{subject}).not_to change{ActionMailer::Base.deliveries.size}
    end

    it 'returns a notification sent result' do
      expect(subject.status).to eq(AcceptProposedOrganisation::Response::INVALID_EMAIL)
    end

    it 'returns the accepted org on the result' do 
      expect(subject.accepted_organisation).to eq Organisation.find_by(name: proposed_org.name)
    end
  end
end
