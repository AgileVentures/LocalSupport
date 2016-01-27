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

    context 'name' do
      it 'is required' do
        expect(FactoryGirl.build(:organisation, name: '')).not_to be_valid
      end
      it 'should have at least three characters' do
        expect(FactoryGirl.build(:organisation, name: 'ab')).not_to be_valid
      end
    end 

    context 'description' do
      it 'is required' do
        expect(FactoryGirl.build(:organisation, description: '')).not_to be_valid
      end
      it 'should have at least three characters' do
        expect(FactoryGirl.build(:organisation, description: 'ab')).not_to be_valid
      end
    end

    context 'postcode' do
      it 'is required' do
        expect(FactoryGirl.build(:organisation, postcode: '')).not_to be_valid
      end
      it 'should have a valid postcode' do
        expect(FactoryGirl.build(:organisation, postcode: 'ABD542')).not_to be_valid
      end
    end

    context 'email' do
      it 'is required' do
        expect(FactoryGirl.build(:organisation, email: '')).not_to be_valid
      end

      it 'should have a valid email' do
        expect(FactoryGirl.build(:organisation, email: 'invalid.email')).not_to be_valid
      end

      it 'should have a unique email address' do
        FactoryGirl.create(:organisation)
        expect(FactoryGirl.build(:organisation, name: 'Awesome charity')).not_to be_valid
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
end
