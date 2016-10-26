require 'rails_helper'
require "pundit/rspec"

RSpec.describe OrganisationReportPolicy do


  subject { described_class }

  permissions :without_users_index? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), :organisation_report)
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), :organisation_report)
    end
  end
end
