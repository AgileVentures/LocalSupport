require 'rails_helper'
require "pundit/rspec"

RSpec.describe PagePolicy do


  subject { described_class }
  permissions :index?, :create?, :update?, :destroy? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), build(:page))
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), build(:page))
    end

    it 'denies access for visitor' do
      expect(subject).not_to permit(nil, build(:page))
    end
  end
end
