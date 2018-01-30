require 'rails_helper'

describe BaseOrganisation, type: :model do
  describe '#validation' do
    it do
      is_expected.to validate_presence_of(:name)
        .with_message("Name can't be blank") 
    end

    it do
      is_expected.to validate_presence_of(:description)
        .with_message("Description can't be blank") 
    end

    it { is_expected.to allow_value('test.com').for(:website) }
    it { is_expected.to allow_value('www.test.com').for(:website) }
    it { is_expected.to allow_value('https://test.co.uk').for(:website) }
    it { is_expected.not_to allow_value('##').for(:website) }
  end

  describe '#has_been_updated_recently?' do
    subject { FactoryBot.create(:organisation, updated_at: Time.now) }

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

  describe 'geocoding object that already exists' do
    subject { FactoryBot.create(:organisation, updated_at: 366.days.ago) }
    it 'should geocode when address changes' do
      new_address = '30 pinner road'
      is_expected.to receive(:geocode)
      subject.update_attributes address: new_address
      end

    it 'should geocode when postcode changes' do
      new_postcode = 'HA1 4RZ'
      is_expected.to receive(:geocode)
      subject.update_attributes postcode: new_postcode
    end
  end

  describe 'geocoding object that is being created' do
    it 'should not geocode if coordinates are setup and I have an address' do
      postcode = 'HA1 4HZ'
      address = '60 pinner road'
      org = FactoryBot.build(
          :organisation,
          address: address,
          latitude: Faker::Address.latitude,
          longitude: Faker::Address.longitude,
          postcode: postcode,
          name: 'Happy and Nice',
          gmaps: true
      )
          expect(org).to_not receive(:geocode)
          org.save
    end

    it 'should geocode if coordinates are not setup and I have an address' do
      postcode = 'HA1 4HZ'
      address = '60 pinner road'
      org = FactoryBot.build(
          :organisation,
          address: address,
          latitude: nil,
          longitude: nil,
          postcode: postcode,
          name: 'Happy and Nice',
          gmaps: true
      )
      expect(org).to receive(:geocode)
      org.save
    end
  end
  
  describe 'friendly_id' do
     
     it 'should use SetupSlug service for setting slugs' do
       service_double = class_double(SetupSlug).as_stubbed_const
       expect(service_double).to receive(:run)
       
       FactoryBot.create(:organisation)
     end
     
  end

end
