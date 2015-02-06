require 'rails_helper'

def check_editability(boolean, array_of_symbols)
  array_of_symbols.each do |sym|
    it "should indicate#{boolean ? '' : ' NOT'} editable for #{sym}" do
      expect(proposed_edit.editable?(sym)).to be boolean
    end
  end
end

describe ProposedOrganisationEdit do

  let(:org) do
    FactoryGirl.create(:organisation,
                       :name => 'Harrow Bereavement Counselling',
                       :description => 'Bereavement Counselling',
                       :address => '64 pinner road',
                       :postcode => 'HA1 3TE',
                       :donation_info => 'www.harrow-bereavment.co.uk/donate')
  end

  let!(:proposed_edit) do
    FactoryGirl.create(:proposed_organisation_edit,
                       :organisation => org )
  end

  describe '::still_pending' do
    let(:archived_edit) do
      FactoryGirl.create(:proposed_organisation_edit,
                         :organisation => org,
                         :archived => true)
    end
    it 'should return all edits that are not yet archived' do
      expect(ProposedOrganisationEdit.all).to include archived_edit
      expect(ProposedOrganisationEdit.still_pending).to eq [proposed_edit] 
    end
  end

  it 'should soft delete associated edits when org is soft deleted' do
      org.destroy
      expect(ProposedOrganisationEdit.all).not_to include proposed_edit
      expect(ProposedOrganisationEdit.with_deleted).to include proposed_edit
  end

  describe '#editable?' do

    check_editability(false, [:address,:telephone])
    check_editability(true, [:name, :description, :postcode, :website, :donation_info, :email])

    context 'when publish field settings are changed' do
      before do
        org.update(:publish_phone => true,
                   :publish_address => true,
                   :publish_email => false)
      end
      check_editability(true, [:address,:telephone])
      check_editability(false, [:email])
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
      it 'should indicate an edit has not been proposed to :name' do 
        expect(proposed_edit.has_proposed_edit?(:name)).to be false
      end
    end
    context 'when an edit to :name has been proposed' do
      let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, :organisation => org, :name => 'Mourning Loved Ones' )}
      it 'should indicate an edit has been proposed' do 
        expect(proposed_edit.has_proposed_edit?(:name)).to be true
      end
    end
  end
end


