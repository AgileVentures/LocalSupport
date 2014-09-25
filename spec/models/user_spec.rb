require 'spec_helper'

describe User do

  let (:model) { mock_model("Organisation") }

  context 'invited users scope' do
    before(:each) do
      @regular_user = FactoryGirl.create(:user, email: 'regular@guy.com')
      @invited_user = FactoryGirl.create(:user_stubbed_organisation, email: 'invited@guy.com', invitation_sent_at: '2014-03-12 00:18:02', invitation_accepted_at: nil)
    end

    it 'finds all users who have not accepted their invitations yet' do
      collection = User.invited_not_accepted
      collection.should_not include(@regular_user)
      collection.should include(@invited_user)
    end

    it 'eager loads the associated organisations' do
      collection = User.invited_not_accepted
      collection.first.association_cache.should_not be_empty
    end
  end

  it 'must find an admin in find_by_admin with true argument' do
    FactoryGirl.create(:user, admin: true)
    result = User.find_by_admin(true)
    result.admin?.should be_true
  end

  it 'must find a non-admin in find_by_admin with false argument' do
    FactoryGirl.create(:user, admin: false)
    result = User.find_by_admin(false)
    result.admin?.should be_false
  end

  it 'does not allow mass assignment of admin for security' do
    user = FactoryGirl.create(:user, admin: false)
    user.update_attributes(:admin => true)
    user.save!
    user.admin.should be_false
  end

  describe '#can_delete?' do
    context 'is admin' do
      subject(:user) { create(:user, admin: true) }

      it 'can edit organisations' do
        user.can_delete?(model).should be_true
      end

    end
    context 'is not admin' do
      subject(:user) { create(:user, admin: false) }

      it 'can edit organisations' do
        user.can_delete?(model).should be_false
      end

    end
  end

  describe '#can_edit?' do
    context 'is admin' do
      subject(:user) { create(:user, admin: true) }

      it 'can edit organisations' do
        user.can_edit?(model).should be_true
      end
    end

    context 'is not admin' do
      let(:non_associated_model) { mock_model("Organisation") }
      subject(:user) { create(:user, admin: false, organisation: model) }

      it 'can edit associated organisation' do
        user.organisation.should eq model
        user.can_edit?(model).should be_true
      end

      it 'can not edit non-associated organisation' do
        user.organisation.should eq model
        user.can_edit?(non_associated_model).should be_false
      end

      it 'can not edit when associated with no org' do
        user.organisation = nil
        user.organisation.should eq nil
        user.can_edit?(non_associated_model).should be_false
      end

      it 'can not edit when associated with no org and attempting to access non-existent org' do
        user.can_edit?(nil).should be_false
      end
    end
  end

  # http://stackoverflow.com/questions/12125038/where-do-i-confirm-user-created-with-factorygirl
  describe '#make_admin_of_org_with_matching_email' do
    before do
      Gmaps4rails.stub(:geocode => nil)
      @user = FactoryGirl.create(:user, email: 'bert@charity.org')
      @admin_user = FactoryGirl.create(:user, email: 'admin@charity.org')
      @mismatch_org = FactoryGirl.create(:organisation, email: 'admin@other_charity.org')
      @match_org = FactoryGirl.create(:organisation, email: 'admin@charity.org')
    end

    it 'should call promote_new_user after confirmation' do
      @user.should_receive(:make_admin_of_org_with_matching_email)
      @user.confirm!
    end

    it 'should not promote the user if org email does not match' do
      @user.make_admin_of_org_with_matching_email
      @user.organisation.should_not eq @mismatch_org
      @user.organisation.should_not eq @match_org
    end

    it 'should not promote the admin user if org email does not match' do
      @admin_user.make_admin_of_org_with_matching_email
      @admin_user.organisation.should_not eq @mismatch_org
    end

    it 'should promote the admin user if org email matches' do
      @admin_user.make_admin_of_org_with_matching_email
      @admin_user.organisation.should eq @match_org
    end

    it 'should be called in #confirm!' do
      @user.should_receive(:make_admin_of_org_with_matching_email)
      @user.confirm!
    end
  end

  describe '#promote_to_org_admin' do
    subject(:user) { User.new }

    it 'gets pending org id' do
      user.should_receive(:pending_organisation_id).and_return('4')
      user.stub(:organisation_id=)
      user.stub(:pending_organisation=)
      user.stub(:save!)
      user.promote_to_org_admin
    end
    it 'sets organisation id to pending_organisation id' do
      user.stub(:pending_organisation_id).and_return('4')
      user.should_receive(:organisation_id=).with('4')
      user.stub(:pending_organisation=)
      user.stub(:save!)
      user.promote_to_org_admin
    end
    it 'sets pending organisation id to nil' do
      user.stub(:pending_organisation_id)
      user.stub(:organisation_id=)
      user.should_receive(:pending_organisation_id=).with(nil)
      user.stub(:save!)
      user.promote_to_org_admin
    end
    it 'saves changes' do
      user.stub(:pending_organisation_id)
      user.stub(:organisation_id=)
      user.stub(:pending_organisation_id=)
      user.should_receive(:save!)
      user.promote_to_org_admin
    end
  end

  describe '#can_request_org_admin?' do
    subject(:user) { User.new }
    before(:each) do
      user.stub(:admin?).and_return(false)
      user.stub(:organisation).and_return(nil)
      user.stub(:pending_organisation).and_return(nil)
      @organisation = double('Organisation')
      @other_organisation = double('Organisation')
    end

    it 'is false when user is site admin' do
      user.should_receive(:admin?).and_return(true)
      user.can_request_org_admin?(@organisation).should be_false
    end

    it 'is false when user is charity admin of this charity' do
      user.should_receive(:organisation).and_return(@organisation)
      user.can_request_org_admin?(@organisation).should be_false
    end

    it 'is true when user is charity admin of another charity' do
      user.should_receive(:organisation).and_return(@other_organisation)
      user.can_request_org_admin?(@organisation).should be_true
    end

    it 'is true when user is charity admin of no charity' do
      user.should_receive(:organisation).and_return(nil)
      user.can_request_org_admin?(@organisation).should be_true
    end

    it 'is false when user is pending charity admin of this charity' do
      user.should_receive(:pending_organisation).and_return(@organisation)
      user.can_request_org_admin?(@organisation).should be_false
    end

    it 'is true when user is pending charity admin of another charity' do
      user.should_receive(:pending_organisation).and_return(@other_organisation)
      user.can_request_org_admin?(@organisation).should be_true
    end

    it 'is true when user is pending charity admin of no charity' do
      user.should_receive(:pending_organisation).and_return(nil)
      user.can_request_org_admin?(@organisation).should be_true
    end

    it 'is true when user is not (site admin || charity admin of this charity || pending charity admin of this charity)' do
      user.can_request_org_admin?(@organisation).should be_true
    end

  end

  context '#request_admin_status' do
    let(:user) { FactoryGirl.build(:user) }
    let(:organisation_id) { 12345 }

    it 'update pending organisation id' do
      user.request_admin_status organisation_id
      expect(user.pending_organisation_id).to eql organisation_id
    end
  end

  describe '#belongs_to?' do
    let(:user) { FactoryGirl.create :user_stubbed_organisation }
    let(:other_org) { FactoryGirl.create :organisation }
    before { Gmaps4rails.stub(:geocode) }

    it 'TRUE: user belongs to it' do
      org = user.organisation
      user.belongs_to?(org).should be true
    end

    it 'FALSE: user does not belong to it' do
      user.belongs_to?(other_org).should be false
    end

  end

  describe '#can_create_volunteer_ops?' do
    let(:user){FactoryGirl.create :user_stubbed_organisation}
    let(:other_org) { FactoryGirl.create :organisation }
    before { Gmaps4rails.stub(:geocode) }

    it 'cannot create volunteer op' do
      user.can_create_volunteer_ops?(other_org).should be_false
    end

    it 'org owner can create volunteer op' do
      user.can_create_volunteer_ops?(user.organisation).should be_true
    end

    it 'site admin can create volunteer op' do
      admin = FactoryGirl.create :user, admin: true
      admin.can_create_volunteer_ops?(other_org).should be_true
    end
  end

  describe "#pending_admin?" do
    let(:user) { FactoryGirl.create :user_stubbed_organisation }
    let(:other_org) { FactoryGirl.create :organisation }

    it 'true when user is pending admin for organisation' do
      user.pending_organisation = other_org
      expect(user.pending_admin? other_org).to be_true
    end

    it 'false when user is not pending admin for organisation' do
      expect(user.pending_admin? other_org).to be_false
    end

    it 'false when org nil' do
      other_org = nil
      expect(user.pending_admin? other_org).to be_false
    end

  end



end
