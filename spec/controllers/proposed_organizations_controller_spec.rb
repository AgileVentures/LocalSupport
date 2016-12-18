require 'rails_helper'

describe ProposedOrganisationsController, :type => :controller do
  let!(:proposed_org) { FactoryGirl.create :proposed_organisation }
  let!(:orphan_org) { FactoryGirl.create :orphan_proposed_organisation }
  let(:user) { FactoryGirl.create :user }
  
  context 'superadmin paths' do
    before(:each) { 
      allow(controller).to receive(:require_superadmin).and_return(true)
    }
    
    context 'PATCH #update' do
      context 'when email is present and organisation is accepted' do
        it 'shows notice flash' do
          patch :update, id: proposed_org.id
          expect(controller).to set_flash[:notice]
        end
        
        it 'returns status 302' do
          patch :update, id: proposed_org.id
          expect(response.status).to eq 302
        end
        
        it 'redirects to organization path' do
          patch :update, id: proposed_org.id
          expect(response).to redirect_to organisation_path(proposed_org)
        end
      end
      
      context 'when email is invalid' do
        shared_examples 'general path' do
          it 'shows error flash' do
            patch :update, id: orphan_org.id
            expect(controller).to set_flash[:error]
          end
          
          it 'returns status 302' do
            patch :update, id: orphan_org.id
            expect(response.status).to eq 302
          end
          
          it 'redirects to proposed organisations path' do
            patch :update, id: orphan_org.id
            expect(response).to redirect_to proposed_organisations_path
          end
        end
        
        context 'when there is no email and organisation is not accepted' do
          before(:each) do
            result = AcceptProposedOrganisation::Response.new(AcceptProposedOrganisation::Response::NO_EMAIL, nil, nil)
            result.not_accepted_org = orphan_org
            allow_any_instance_of(AcceptProposedOrganisation).to receive(:run).and_return(result)
          end
          
          it 'shows error flash with a certain message' do
            patch :update, id: orphan_org.id
            expect(flash[:error]).to have_text('No invitation email was sent because no email is associated with the organisation')
          end
          
          it_behaves_like 'general path'
        end
        
        context 'when there is invalid email and organisation is not accepted' do
          before(:each) do
            result = AcceptProposedOrganisation::Response.new(AcceptProposedOrganisation::Response::INVALID_EMAIL, nil, nil)
            result.not_accepted_org = orphan_org
            allow_any_instance_of(AcceptProposedOrganisation).to receive(:run).and_return(result)
          end
          
          it 'shows error flash with a certain message' do
            patch :update, id: orphan_org.id
            expect(flash[:error]).to have_text(
              "No invitation email was sent because the email associated with #{
                orphan_org.name}, #{orphan_org.email}, seems invalid"
            )
          end
          
          it_behaves_like 'general path'
        end
      end
    end
  end
  
  context 'other users\' paths' do
    before(:each) { 
      allow_any_instance_of(User).to receive(:try).with(:superadmin?).and_return(false)
    }
    
    context 'PATCH #update' do
      shared_examples 'permission is denied' do
        it 'shows warning flash' do
          patch :update, id: proposed_org.id
          expect(controller).to set_flash[:warning]
        end
        
        it 'returns status 302' do
          patch :update, id: proposed_org.id
          expect(response.status).to eq 302
        end
        
        it 'redirects to organisation path' do
          patch :update, id: proposed_org.id
          expect(response).to redirect_to root_path
        end
      end
      
      context 'when email is present and organisation is accepted' do
        it_behaves_like 'permission is denied'
      end
      
      context 'when email is invalid' do
        context 'when there is no email and organisation is not accepted' do
          it_behaves_like 'permission is denied'
        end
        
        context 'when there is invalid email and organisation is not accepted' do
          it_behaves_like 'permission is denied'
        end
      end
    end
  end
end