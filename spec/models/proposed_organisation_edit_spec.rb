require 'rails_helper'
def check_viewability(boolean, usr, array_of_symbols)
  array_of_symbols.each do |sym|
    it "should indicate#{boolean ? '' : ' NOT'} viewable for #{sym}" do
      user = case usr
        when :regular_user
          regular_user 
        when :siteadmin
          siteadmin
        when :superadmin
          superadmin
        else
          {}
        end
      expect(proposed_edit.viewable_field?(sym, by: user)).to be boolean
    end
  end    
end
def check_editability(boolean, usr, array_of_symbols)
  array_of_symbols.each do |sym|
    it "should indicate#{boolean ? '' : ' NOT'} editable for #{sym}" do
      user = case usr
        when :regular_user
          regular_user 
        when :siteadmin
          siteadmin
        else
          {}
        end
      expect(proposed_edit.editable?(sym, by: user)).to be boolean
    end
  end
end

describe ProposedOrganisationEdit do

  let(:regular_user) do
    FactoryGirl.create(:user, :email => "regularjoe@example.com", :password => 'asdf1234', :password_confirmation =>
      'asdf1234', :siteadmin => false)
   end
  let(:superadmin) do
    FactoryGirl.create(:user, :email => "superadmin@example.com", :password => 'asdf1234', :password_confirmation =>
      'asdf1234', :superadmin => true)
   end

  let(:siteadmin) do
    FactoryGirl.create(:user, :email => "siteadmin@example.com", :password => 'asdf1234', :password_confirmation =>
      'asdf1234', :siteadmin => true)
   end

  let(:org) do
    FactoryGirl.create(:organisation,
                       :name => 'Harrow Bereavement Counselling',
                       :description => 'Bereavement Counselling',
                       :address => '64 pinner road',
                       :postcode => 'HA1 4HZ',
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

  describe '#viewable_field?' do
    context 'when publish fields are all false and user is regular user' do
      before do 
        org.update(:publish_email => false)
      end
      check_viewability(false, :regular_user, [:address, :telephone, :email])
    end
    context 'when publish fields are all true and user is regular user' do
      before do 
        org.update(:publish_phone => true, :publish_address => true)
      end
      check_viewability(true, :regular_user, [:address, :telephone, :email])
    end
    context 'when publish fields are all false but user is siteadmin' do
      before do
        org.update(:publish_email => false)
      end
      check_viewability(true, :siteadmin, [:address, :telephone, :email])
    end
    context 'when publish fields are all true and user is siteadmin' do
      before do
        org.update(:publish_phone => true, :publish_address => true)
      end
      check_viewability(true, :siteadmin, [:address, :telephone, :email])
    end
    context 'when publish fields are all false but user is superadmin' do
      before do
        org.update(:publish_email => false)
      end
      check_viewability(true, :superadmin, [:address, :telephone, :email])
    end
   context 'when publish fields are all true and user is superadmin' do
      before do
        org.update(:publish_phone => true, :publish_address => true)
      end
      check_viewability(true, :superadmin, [:address, :telephone, :email])
    end
  end
  describe '#editable?' do
    
    check_editability(false, :regular_user, [:address,:telephone])
    check_editability(true, :regular_user, [:name, :description, :postcode, :website, :donation_info, :email])

    context 'when publish field settings are changed' do
      before do
        org.update(:publish_phone => true,
                   :publish_address => true,
                   :publish_email => false)
      end
      check_editability(true, :regular_user, [:address,:telephone])
      check_editability(false, :regular_user, [:email])
    end
    
    context 'when editor is siteadmin' do
      before do 
        org.update(:publish_email => false)
      end
      check_editability(true, :siteadmin, [:address, :telephone, :email])
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
                                   :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ',
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


