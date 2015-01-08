require 'rails_helper'

describe ProposedOrganisationEdit do
  let(:org){FactoryGirl.create(:organisation, :email => nil, :name => 'Harrow Bereavement Counselling',
                               :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE',
                               :donation_info => 'www.harrow-bereavment.co.uk/donate')}
  let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org )}
  it{expect(proposed_edit.organisation).to eq org}
  describe '#editable?' do
      it{expect(proposed_edit.editable?(:address)).to be false}
      it 'true only if publish_address is true' do
        org.publish_address = true
        org.save!
        expect(proposed_edit.editable?(:address)).to be true
      end
  end
end