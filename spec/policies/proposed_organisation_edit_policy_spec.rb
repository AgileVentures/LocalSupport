require 'rails_helper'
require "pundit/rspec"

RSpec.describe ProposedOrganisationEditPolicy do


  subject { described_class }

  permissions :update? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:proposed_organisation_edit))
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), build(:proposed_organisation_edit))
    end
  end

end
