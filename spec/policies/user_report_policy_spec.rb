require 'rails_helper'
require "pundit/rspec"

RSpec.describe UserReportPolicy do

  let(:user) { User.new }

  subject { described_class }

  permissions :access? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), :user_report)
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), :user_report)
    end
  end
end
