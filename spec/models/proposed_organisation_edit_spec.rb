require 'rails_helper'

describe ProposedOrganisationEdit do

  describe '#editable?' do
      let(:org){FactoryGirl.create(:organisation, :email => nil, :name => 'Harrow Bereavement Counselling',
                                  :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE',
                                  :donation_info => 'www.harrow-bereavment.co.uk/donate')}
      let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org )}

    it{expect(proposed_edit.organisation).to eq org}
  end
end