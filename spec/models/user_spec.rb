require 'rails_helper'

describe User, :type => :model do

  let (:model) { mock_model("Organisation", :_read_attribute => 1)}

  context 'invited users scope' do
    before(:each) do
      @regular_user = FactoryGirl.create(:user, email: 'regular@guy.com')
      @invited_user = FactoryGirl.create(:user_stubbed_organisation, email: 'invited@guy.com', invitation_sent_at: '2014-03-12 00:18:02', invitation_accepted_at: nil)
    end

    it 'finds all users who have not accepted their invitations yet' do
      collection = User.invited_not_accepted
      expect(collection).not_to include(@regular_user)
      expect(collection).to include(@invited_user)
    end

    it 'eager loads the associated organisations' do
      collection = User.invited_not_accepted
      expect(collection.first.association_cache).not_to be_empty
    end
  end

  it 'must find an superadmin in find_by_superadmin with true argument' do
    FactoryGirl.create(:user, superadmin: true)
    result = User.find_by_superadmin(true)
    expect(result.superadmin?).to be true
  end

  it 'must find a non-superadmin in find_by_superadmin with false argument' do
    FactoryGirl.create(:user, superadmin: false)
    result = User.find_by_superadmin(false)
    expect(result.superadmin?).to be false
  end

  describe '#can_delete?' do
    context 'is superadmin' do
      subject(:user) { create(:user, superadmin: true) }

      it 'can edit organisations' do
        expect(user.can_delete?(model)).to be true
      end

    end
    context 'is not superadmin' do
      subject(:user) { create(:user, superadmin: false) }

      it 'can edit organisations' do
        expect(user.can_delete?(model)).to be false
      end

    end
  end

  describe '#can_edit?' do
    context 'is superadmin' do
      subject(:user) { create(:user, superadmin: true) }

      it 'can edit organisations' do
        expect(user.can_edit?(model)).to be true
      end
    end

    context 'is not superadmin' do
      let(:non_associated_model) { mock_model("Organisation") }
      subject(:user) { create(:user, superadmin: false, organisation: model) }

      it 'can edit associated organisation' do
        expect(user.organisation).to eq model
        expect(user.can_edit?(model)).to be true
      end

      it 'can not edit non-associated organisation' do
        expect(user.organisation).to eq model
        expect(user.can_edit?(non_associated_model)).to be false
      end

      it 'can not edit when associated with no org' do
        user.organisation = nil
        expect(user.organisation).to eq nil
        expect(user.can_edit?(non_associated_model)).to be false
      end

      it 'can not edit when associated with no org and attempting to access non-existent org' do
        expect(user.can_edit?(nil)).to be false
      end
    end
  end

  # http://stackoverflow.com/questions/12125038/where-do-i-confirm-user-created-with-factorygirl
  describe '#make_admin_of_org_with_matching_email' do
    before do
      @user = FactoryGirl.create(:user, email: 'bert@charity.org')
      @superadmin_user = FactoryGirl.create(:user, email: 'superadmin@charity.org')
      @mismatch_org = FactoryGirl.create(:organisation, email: 'superadmin@other_charity.org')
      @match_org = FactoryGirl.create(:organisation, email: 'superadmin@charity.org')
    end

    it 'should call promote_new_user after confirmation' do
      expect(@user).to receive(:make_admin_of_org_with_matching_email)
      @user.confirm!
    end

    it 'should not promote the user if org email does not match' do
      @user.make_admin_of_org_with_matching_email
      expect(@user.organisation).not_to eq @mismatch_org
      expect(@user.organisation).not_to eq @match_org
    end

    it 'should not promote the admin user if org email does not match' do
      @superadmin_user.make_admin_of_org_with_matching_email
      expect(@superadmin_user.organisation).not_to eq @mismatch_org
    end

    it 'should promote the admin user if org email matches' do
      @superadmin_user.make_admin_of_org_with_matching_email
      expect(@superadmin_user.organisation).to eq @match_org
    end

    it 'should be called in #confirm!' do
      expect(@user).to receive(:make_admin_of_org_with_matching_email)
      @user.confirm!
    end
  end

  describe '#promote_to_org_admin' do
    subject(:user) { User.new }

    it 'gets pending org id' do
      expect(user).to receive(:pending_organisation_id).and_return('4')
      allow(user).to receive(:organisation_id=)
      allow(user).to receive(:pending_organisation=)
      allow(user).to receive(:save!)
      user.promote_to_org_admin
    end
    it 'sets organisation id to pending_organisation id' do
      allow(user).to receive(:pending_organisation_id).and_return('4')
      expect(user).to receive(:organisation_id=).with('4')
      allow(user).to receive(:pending_organisation=)
      allow(user).to receive(:save!)
      user.promote_to_org_admin
    end
    it 'sets pending organisation id to nil' do
      allow(user).to receive(:pending_organisation_id)
      allow(user).to receive(:organisation_id=)
      expect(user).to receive(:pending_organisation_id=).with(nil)
      allow(user).to receive(:save!)
      user.promote_to_org_admin
    end
    it 'saves changes' do
      allow(user).to receive(:pending_organisation_id)
      allow(user).to receive(:organisation_id=)
      allow(user).to receive(:pending_organisation_id=)
      expect(user).to receive(:save!)
      user.promote_to_org_admin
    end
  end

  describe '#can_request_org_admin?' do
    subject(:user) { User.new }
    before(:each) do
      allow(user).to receive(:superadmin?).and_return(false)
      allow(user).to receive(:organisation).and_return(nil)
      allow(user).to receive(:pending_organisation).and_return(nil)
      @organisation = double('Organisation')
      @other_organisation = double('Organisation')
    end

    it 'is false when user is site superadmin' do
      expect(user).to receive(:superadmin?).and_return(true)
      expect(user.can_request_org_admin?(@organisation)).to be false
    end

    it 'is false when user is organisation admin of this organisation' do
      expect(user).to receive(:organisation).and_return(@organisation)
      expect(user.can_request_org_admin?(@organisation)).to be false
    end

    it 'is true when user is organisation admin of another organisation' do
      expect(user).to receive(:organisation).and_return(@other_organisation)
      expect(user.can_request_org_admin?(@organisation)).to be true
    end

    it 'is true when user is organisation admin of no organisation' do
      expect(user).to receive(:organisation).and_return(nil)
      expect(user.can_request_org_admin?(@organisation)).to be true
    end

    it 'is false when user is pending organisation admin of this organisation' do
      expect(user).to receive(:pending_organisation).and_return(@organisation)
      expect(user.can_request_org_admin?(@organisation)).to be false
    end

    it 'is true when user is pending organisation admin of another organisation' do
      expect(user).to receive(:pending_organisation).and_return(@other_organisation)
      expect(user.can_request_org_admin?(@organisation)).to be true
    end

    it 'is true when user is pending organisation admin of no organisation' do
      expect(user).to receive(:pending_organisation).and_return(nil)
      expect(user.can_request_org_admin?(@organisation)).to be true
    end

    it 'is true when user is not (site superadmin || organisation admin of this organisation || pending organisation admin of this organisation)' do
      expect(user.can_request_org_admin?(@organisation)).to be true
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

    it 'TRUE: user belongs to it' do
      org = user.organisation
      expect(user.belongs_to?(org)).to be true
    end

    it 'FALSE: user does not belong to it' do
      expect(user.belongs_to?(other_org)).to be false
    end

  end

  describe '#can_create_volunteer_ops?' do
    let(:user){FactoryGirl.create :user_stubbed_organisation}
    let(:other_org) { FactoryGirl.create :organisation }

    it 'cannot create volunteer op' do
      expect(user.can_create_volunteer_ops?(other_org)).to be false
    end

    it 'org owner can create volunteer op' do
      expect(user.can_create_volunteer_ops?(user.organisation)).to be true
    end

    it 'site superadmin can create volunteer op' do
      superadmin = FactoryGirl.create :user, superadmin: true
      expect(superadmin.can_create_volunteer_ops?(other_org)).to be true
    end
  end

  describe "#pending_org_admin?" do
    let(:user) { FactoryGirl.create :user_stubbed_organisation }
    let(:other_org) { FactoryGirl.create :organisation }

    it 'true when user is pending admin for organisation' do
      user.pending_organisation = other_org
      expect(user.pending_org_admin? other_org).to be true
    end

    it 'false when user is not pending admin for organisation' do
      expect(user.pending_org_admin? other_org).to be false
    end

    it 'false when org nil' do
      other_org = nil
      expect(user.pending_org_admin? other_org).to be false
    end

  end

  describe 'destroy uses acts_as_paranoid' do
    let(:user){FactoryGirl.create :user}
    it 'can be restored' do
      email = user.email
      user.destroy
      expect(User.find_by_email(email)).to eq nil
      User.with_deleted.find_by_email(email).restore
      expect(User.find_by_email(email)).to eq user
    end
  end

  describe '.purge_deleted_users_where' do
    subject(:do_purge) { User.purge_deleted_users_where(email: 'yes@hello.com') }
    it 'purge deleted user when user match query' do
      user = FactoryGirl.create :deleted_user, email: 'yes@hello.com'
      expect { do_purge }.to change(User.deleted, :count).by(-1)
    end
    it 'does not delete users that is not match query' do
      user = FactoryGirl.create :deleted_user, email: 'no@hello.com'
      expect { do_purge }.to change(User.deleted, :count).by(0)
    end
    it 'does not affect undeleted users' do
      user = FactoryGirl.create :user, email: 'yes@hello.com'
      expect { do_purge }.to change(User, :count).by(0)
    end
  end
end
