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

  describe "#not_updated_recently_or_has_no_owner?" do
    subject { FactoryGirl.create(:organisation, :name => "Org with no owner", :updated_at => 364.day.ago) }

    context 'has no owner but updated recently' do
      it { is_expected.to be_not_updated_recently_or_has_no_owner }
    end

    context 'has owner but old update' do
      subject { FactoryGirl.create(:organisation_with_owner, :updated_at => 366.day.ago) }
      it { is_expected.to be_not_updated_recently_or_has_no_owner }
    end

    context 'has no owner and old update' do
      subject { FactoryGirl.create(:organisation, :updated_at => 366.day.ago) }
      it { is_expected.to be_not_updated_recently_or_has_no_owner }
    end

    context 'has owner and recent update' do
      subject { FactoryGirl.create(:organisation_with_owner, :updated_at => 364.day.ago) }
      it { is_expected.not_to be_not_updated_recently_or_has_no_owner }
    end
  end
end