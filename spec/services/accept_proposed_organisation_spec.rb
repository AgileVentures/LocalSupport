require 'rails_helper'

describe  AcceptProposedOrganisation do
  let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: email)}
  let(:subject){AcceptProposedOrganisation.new(proposed_org).run}
  
  context 'organisation can be accepted' do
    shared_examples 'acceptance steps' do
      it 'associates the user with the organisation' do
        subject
        expect(User.find_by(email: email).organisation).to eq Organisation.find(proposed_org.id)
      end
  
      it 'promotes the proposed org to org' do
        expect(->{subject}).to change(Organisation, :count).by 1
      end
  
      it 'has one less proposed organisation' do
        expect(->{subject}).to change(ProposedOrganisation, :count).by(-1)
      end
  
      it 'sends an email' do
        expect(->{subject}).to change{ActionMailer::Base.deliveries.size}.by(1)
      end
      
      it 'returns the accepted org on the result' do 
        expect(subject.accepted_org).to eq Organisation.find_by(name: proposed_org.name)
      end
      
      it 'returns nil as not accepted organisation on the result' do 
        expect(subject.not_accepted_org).to be nil
      end
    end
    
    context 'proposed organisation email is not registered' do
      let(:email){"user@email.com"}
      
      it 'creates a user' do
        expect(->{subject}).to change(User, :count).by 1
      end
  
      it 'returns an invitation sent result' do
        expect(subject.status).to eq(AcceptProposedOrganisation::Response::INVITATION_SENT)
      end
      
      it_behaves_like 'acceptance steps'
    end
  
    context 'proposed organisation email is a registered user' do
      let(:email){"user@email.com"}
      let!(:user){FactoryGirl.create(:user, email: email)}
      
      it 'returns a notification sent result' do
        expect(subject.status).to eq(AcceptProposedOrganisation::Response::NOTIFICATION_SENT)
      end
      
      it_behaves_like 'acceptance steps'
    end
  end

  context 'organisation cannot be accepted' do
    shared_examples 'non acceptance steps' do
      it 'does not promote the proposed org to org' do
        expect(->{subject}).to change(Organisation, :count).by 0
      end
  
      it 'has the same number of proposed organisations' do
        expect(->{subject}).to change(ProposedOrganisation, :count).by 0
      end
  
      it 'does not send an email' do
        expect(->{subject}).not_to change{ActionMailer::Base.deliveries.size}
      end
  
      it 'does not return accepted org on the result' do 
        expect(subject.accepted_org).to be nil
      end
      
      it 'converts organisation back and returns it on the result' do 
        expect(subject.not_accepted_org.type).to eq('ProposedOrganisation')
      end
    end
    
    context 'proposed organisation has no email' do
      let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: "")}
  
      it 'returns a notification sent result' do
        expect(subject.status).to eq(AcceptProposedOrganisation::Response::NO_EMAIL)
      end
      
      it_behaves_like 'non acceptance steps'
    end
  
    context 'proposed organisation has invalid email' do
      let!(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation, email: "invalidemail.com")}
  
      it 'returns a notification sent result' do
        expect(subject.status).to eq(AcceptProposedOrganisation::Response::INVALID_EMAIL)
      end
      
      it_behaves_like 'non acceptance steps'
    end
  end
end
