require 'rails_helper'
require "pundit/rspec"

RSpec.describe VolunteerOpPolicy do


  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:volunteer_op))
    end

    it 'grants access for organisation owner' do
      organisation = create(:organisation)
      user = create(:user, organisation_id: organisation.id)
      expect(subject).to permit(user, build(:volunteer_op, organisation_id: organisation.id))
    end

    it 'denies access for non organisation owner' do
      organisation = create(:organisation)
      expect(subject).not_to permit(build(:user), build(:volunteer_op, organisation_id: organisation.id))
    end
  end
end
