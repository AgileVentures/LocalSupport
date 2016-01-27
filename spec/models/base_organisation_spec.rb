require 'rails_helper'

describe BaseOrganisation, type: :model do
  describe '#validation' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:organisation)).to be_valid
    end 
    
    context 'website and donation_info url' do
      it 'is not required' do
        expect(FactoryGirl.build(:organisation, website: '', donation_info: '')).to be_valid
      end
      it 'should be a valid url' do
        expect(FactoryGirl.build(:organisation, website: '##')).not_to be_valid
      end
    end

    context 'required fields: name, description, postcode, email' do
      it 'should have a name' do
        expect(FactoryGirl.build(:organisation, name: '')).not_to be_valid
      end
      it 'should have a description' do
        expect(FactoryGirl.build(:organisation, description: '')).not_to be_valid
      end
      it 'should have a postcode' do
        expect(FactoryGirl.build(:organisation, postcode: '')).not_to be_valid
      end
      it 'should have an email' do
        expect(FactoryGirl.build(:organisation, email: '')).not_to be_valid
      end
    end

    context 'email' do
      it 'should have a valid email' do
        expect(FactoryGirl.build(:organisation, email: 'invalid.email')).not_to be_valid
      end
    end
  end

  describe '#has_been_updated_recently?' do
    subject { FactoryGirl.create(:organisation, updated_at: Time.now) }

    it { is_expected.to have_been_updated_recently }

    context "updated too long ago" do
      subject { FactoryGirl.create(:organisation, updated_at: 365.days.ago)}
      it { is_expected.not_to have_been_updated_recently }
    end

    context "when updated recently" do
      subject { FactoryGirl.create(:organisation, updated_at: 364.days.ago) }
      it { is_expected.to have_been_updated_recently }
    end
  end

  describe 'geocoding' do
    subject { FactoryGirl.create(:organisation, updated_at: 366.days.ago) }
    it 'should geocode when address changes' do
      new_address = '30 pinner road'
      is_expected.to receive(:geocode)
      subject.update_attributes :address => new_address
    end

    it 'should geocode when postcode changes' do
      new_postcode = 'HA1 4RZ'
      is_expected.to receive(:geocode)
      subject.update_attributes :postcode => new_postcode
    end

    it 'should geocode when new object is created' do
      address = '60 pinner road'
      postcode = 'HA1 4HZ'
      org = FactoryGirl.build(:organisation,:address => address, :postcode => postcode, :name => 'Happy and Nice', :gmaps => true)
      expect(org).to receive(:geocode)
      org.save
    end
  end

  describe '#add_url_protocol' do
    it 'should add the url protocol if absent' do
      org = FactoryGirl.create(:organisation, :website => 'friendly.org')
      org.add_url_protocol
      expect(org.website).to eq 'http://friendly.org'
    end

    it 'should leave url unchanged if prototcol present' do
      org = FactoryGirl.create(:organisation, :website => 'https://www.sup.org')
      org.add_url_protocol
      expect(org.website).to eq 'https://www.sup.org'
    end

    it 'should ignore empty urls' do
      org = FactoryGirl.create(:organisation, :website => '')
      org.add_url_protocol
      expect(org.website).to eq ''
    end
  end
end
