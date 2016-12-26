require 'rails_helper'

describe ProposedOrganisation, :type => :model do
  let!(:proposed_org){FactoryGirl.create :proposed_organisation}
  let!(:owner){proposed_org.users.first}
  let(:new_org){proposed_org.accept_proposal}
  
  context 'with associated user' do
    it 'retains associated user after approval' do
      expect(new_org.users.first).to eq owner
    end
    it 'returns an organisation' do
      expect(new_org.class).to eq Organisation
    end
    it 'expunges the proposed organisation' do
      expect(proposed_org.id).to eq new_org.id
      expect{ProposedOrganisation.find proposed_org.id}.to raise_error ActiveRecord::RecordNotFound
    end
    [:name, :description, :address, :longitude, :latitude, :email, :postcode, :publish_email, :publish_phone,
    :donation_info, :website, :publish_address, :telephone].each do |attr|
      it "#{attr} is retained" do
        expect(new_org.send(attr)).to eq(proposed_org.send(attr))
      end
    end
  end
  
  context '#accept_proposal' do
    it 'changes organisation\'s type if it is accepted' do
      proposed_org.accept_proposal
      expect(proposed_org.type).to eq('Organisation')
    end
    
    it 'does not change organisation\'s type if it is not accepted' do
      proposed_org.accept_proposal(true)
      expect(proposed_org.type).to eq('ProposedOrganisation')
    end
  end
end
