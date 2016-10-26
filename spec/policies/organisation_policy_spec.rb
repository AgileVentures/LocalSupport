require 'rails_helper'
require "pundit/rspec"

RSpec.describe OrganisationPolicy do


  subject { described_class }

  permissions :create?, :destroy? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:organisation))
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), build(:organisation))
    end
  end

  permissions :update? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:organisation))
    end

    it 'grants access for organisation owner' do
      organisation = create(:organisation)
      org_owner = create(:user, organisation: organisation)
      expect(subject).to permit(org_owner, organisation)
    end

    it 'denies access for non organisation owner' do
      expect(subject).not_to permit(build(:user), build(:organisation))
    end
  end

  permissions :propose_edits? do
    it 'denies access for superadmin' do
      expect(subject).not_to permit(build(:user, superadmin: true), build(:organisation))
    end

    it 'denies access for organisation owner' do
      organisation = create(:organisation)
      org_owner = create(:user, organisation: organisation)
      expect(subject).not_to permit(org_owner, organisation)
    end
    
    it 'denies access for visitor' do
      expect(subject).not_to permit(nil, build(:organisation))
    end

    it 'grants access for non organisation owner' do
      expect(subject).to permit(build(:user), build(:organisation))
    end
  end

  permissions :grabbable? do
    it 'denies access for superadmin' do
      expect(subject).not_to permit(build(:user, superadmin: true), build(:organisation))
    end

    it 'denies access for organisation owner' do
      organisation = create(:organisation)
      org_owner = create(:user, organisation: organisation)
      expect(subject).not_to permit(org_owner, organisation)
    end
    
    it 'denies access for user with organisation as pending organisation' do
      organisation = create(:organisation)
      user = create(:user, pending_organisation: organisation)
      expect(subject).not_to permit(user, organisation)
    end

    it 'grants access for non organisation owner' do
      expect(subject).to permit(build(:user), build(:organisation))
    end

    it 'grants access for visitor' do
      expect(subject).to permit(nil, build(:organisation))
    end
  end
end
