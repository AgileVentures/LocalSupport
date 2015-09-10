require 'rails_helper'

describe BaseOrganisation, type: :model do
  describe '#not_updated_recently?' do
    subject { FactoryGirl.create(:organisation, updated_at: Time.now) }

    it { is_expected.not_to be_not_updated_recently }

    context "updated too long ago" do
      subject { FactoryGirl.create(:organisation, updated_at: 365.days.ago)}
      it { is_expected.to be_not_updated_recently }
    end

    context "when updated recently" do
      subject { FactoryGirl.create(:organisation, updated_at: 364.days.ago) }
      it { is_expected.not_to be_not_updated_recently }
    end
  end
end