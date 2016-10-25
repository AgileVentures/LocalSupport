require 'rails_helper'
require "pundit/rspec"

RSpec.describe MailTemplatePolicy do


  subject { described_class }

  permissions :update? do
    it 'grants access for superadmin' do
      expect(subject).to permit(build(:user, superadmin: true), MailTemplate.new)
    end

    it 'denies access for user' do
      expect(subject).not_to permit(build(:user), MailTemplate.new)
    end
  end
end
