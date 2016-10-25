require 'rails_helper'
require "pundit/rspec"

RSpec.describe InvitationPolicy do


  subject { described_class }

  permissions :create? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), :invitation)
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), :invitation)
    end
  end
end
