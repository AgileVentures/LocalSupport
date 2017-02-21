require 'rails_helper'

describe  CreateFlashForProposedOrganisation do
  let!(:result) { AcceptProposedOrganisation.new(org).run }
  let(:subject) { CreateFlashForProposedOrganisation.new(result).run }
  
  context 'proposed organisation was accepted' do
    let!(:org) { FactoryGirl.create(:proposed_organisation, email: email) }
    
    context 'invitation was sent' do
      let(:email){ 'some_valid_email@email.com' }
      
      it 'two notice flash messages are returned' do
        expect(subject).to match(notice: [
          'You have approved the following organisation',
          "An invitation email was sent to #{result.accepted_org.email}"
        ])
      end
    end
    
    context 'notification was sent' do
      let!(:user){ FactoryGirl.create(:user) }
      let(:email){ user.email }

      it 'two notice flash messages are returned' do
        expect(subject).to match(notice: [
          'You have approved the following organisation',
          "A notification of acceptance was sent to #{result.accepted_org.email}"
        ])
      end
    end
  end
  
  context 'proposed organisation was not accepted' do
    let!(:org) { FactoryGirl.create(:orphan_proposed_organisation, email: email) }
    
    context 'no email was sent because of no email address' do
      let(:email){ '' }
      
      it 'error flash message is returned' do
        expect(subject).to match(error: 'No invitation email was sent because no email is associated with the organisation')
      end
    end
    
    context 'no email was sent because of invalid email address' do
      let(:email){ 'some_invalid_email.com' }

      it 'error flash message is returned' do
        expect(subject).to match(error: "No invitation email was sent because the email associated with " +
          "#{result.not_accepted_org.name}, #{result.not_accepted_org.email}, seems invalid")
      end
    end
  end
end