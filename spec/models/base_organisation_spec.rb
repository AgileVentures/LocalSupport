require 'rails_helper'

describe BaseOrganisation, type: :model do
  describe '#validation' do
    it do
      is_expected.to validate_presence_of(:name)
        .with_message("Name can't be blank") 
    end

    it { is_expected.to allow_value('test.com').for(:website) }
    it { is_expected.to allow_value('www.test.com').for(:website) }
    it { is_expected.to allow_value('https://test.co.uk').for(:website) }
    it { is_expected.not_to allow_value('##').for(:website) }
  end

  describe '#has_been_updated_recently?' do
    subject { FactoryBot.create(:organisation, updated_at: Time.zone.now) }

    it { is_expected.to have_been_updated_recently }

    context 'updated too long ago' do
      subject { FactoryBot.create(:organisation, updated_at: 1.year.ago)}
      it { is_expected.not_to have_been_updated_recently }
    end

    context 'when updated recently' do
      subject { FactoryBot.create(:organisation, updated_at: 364.days.ago) }
      it { is_expected.to have_been_updated_recently }
    end
  end

  describe 'friendly_id' do
    it 'should use SetupSlug service for setting slugs' do
      service_double = class_double(SetupSlug).as_stubbed_const
      expect(service_double).to receive(:run)
      FactoryBot.create(:organisation)
    end
  end

  describe 'full_address' do
    it 'should be composed of address and postcode' do
      organisation = FactoryBot.create(:organisation)
      full_address  = "#{organisation.address}, #{organisation.postcode}"
      expect(organisation.full_address).to eq(full_address)
    end
    it 'should be just address when postcode is not present' do
      organisation = FactoryBot.create(:organisation, postcode: ' ')
      expect(organisation.full_address).to eq(organisation.address)
    end
    it 'should be just postcode when address is not present' do
      organisation = FactoryBot.create(:organisation, address: ' ')
      expect(organisation.full_address).to eq(organisation.postcode)
    end
  end
end
