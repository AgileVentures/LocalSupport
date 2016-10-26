require 'rails_helper'
require "pundit/rspec"

RSpec.describe ProposedOrganisationPolicy do


  subject { described_class }


  permissions :update?, :destroy? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:proposed_organisation))
    end

    it 'denies access for user' do
      organisation = create(:organisation)
      expect(subject).not_to permit(build(:user), build(:proposed_organisation))
    end
  end
end
