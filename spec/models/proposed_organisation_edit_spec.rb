require 'rails_helper'

describe ProposedOrganisationEdit do
  let(:org){FactoryGirl.create(:organisation, :name => 'Harrow Bereavement Counselling',
                               :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE',
                               :donation_info => 'www.harrow-bereavment.co.uk/donate')}
  let!(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org )}
  it{expect(proposed_edit.organisation).to eq org}
  describe '::still_pending' do
    let(:archived_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org, :archived => true)}
    it 'returns non archived edits' do
      expect(ProposedOrganisationEdit.all).to include archived_edit
      expect(ProposedOrganisationEdit.still_pending).to eq [proposed_edit] 
    end
  end

  describe 'soft delete of associated edits when org is soft deleted' do
    it do
      org.destroy
      expect(ProposedOrganisationEdit.all).not_to include proposed_edit
      expect(ProposedOrganisationEdit.with_deleted).to include proposed_edit
    end
  end
  describe '#editable?' do
      [:address,:telephone].each do |sym|
          it{expect(proposed_edit.editable?(sym)).to be false}
      end
      it{expect(proposed_edit.editable?(:email)).to be true}
      [:name, :description, :postcode, :website, :donation_info].each do |sym|
        it{expect(proposed_edit.editable?(sym)).to be true}
      end
      context 'opposite of default setting for publish fields' do
        let(:org){FactoryGirl.create(:organisation, :name => 'Harrow Bereavement Counselling',
                                     :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE',
                                     :donation_info => 'www.harrow-bereavment.co.uk/donate', :publish_phone => true, :publish_address => true,
                                     :publish_email => false)}
        [:address,:telephone].each do |sym|
          it{expect(proposed_edit.editable?(sym)).to be true}
        end
        it{expect(proposed_edit.editable?(:email)).to be false}
      end

  end
  describe '#non_published_editable_fields' do
    let(:org){FactoryGirl.create(:organisation, :name => "Happy Org", :publish_email => false)}
    context 'all fields are private' do
      it 'returns email, telephone and address but nothing else' do
        expect(proposed_edit.non_published_generally_editable_fields).to include :email, :telephone, :address
        expect(proposed_edit.non_published_generally_editable_fields).not_to include :name, :postcode, :description, :donation_info, :website
      end
    end
    context 'address is public' do
      let(:org){FactoryGirl.create(:organisation, :name => "Happy Org", :publish_email => false, :publish_address => true)}
      it 'returns email, and telephone but not address' do
        expect(proposed_edit.non_published_generally_editable_fields).to include :email, :telephone
        expect(proposed_edit.non_published_generally_editable_fields).not_to include :address, :name, :postcode, :description, :donation_info, :website
      end
    end
  end
  describe "#accept" do
    context 'update with params' do
      let(:org){FactoryGirl.create(:organisation, :name => 'Harrow Bereavement Counselling',
                                   :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE',
                                   :donation_info => 'www.harrow-bereavment.co.uk/donate')}
      let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org )}
      it 'updates the name attribute' do
        expect{
          proposed_edit.accept("name" => "Care for the Elderly")
        }.to change(org, :name).to("Care for the Elderly")
      end
      it do
        expect{
          proposed_edit.accept("name" => "Care for the Elderly")
        }.to change(proposed_edit, :accepted).from(false).to true
      end
      it do
        expect{
          proposed_edit.accept("name" => "Care for the Elderly")
        }.to change(proposed_edit, :archived).from(false).to true
      end
    end

  end
  describe '#has_proposed_edit?' do
    context 'when an edit to :name has not been proposed' do
      let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org, :name => 'Harrow Bereavement Counselling' )}
      it{expect(proposed_edit.has_proposed_edit?(:name)).to be false }
    end
    context 'when an edit to :name has been proposed' do
      let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org, :name => 'Harrow Bereavement Counseling' )}
      it{expect(proposed_edit.has_proposed_edit?(:name)).to be true }
    end
    context 'editabilty has changed' do
      pending
    end
  end
end
