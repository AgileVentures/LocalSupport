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
    subject { FactoryGirl.create(:organisation, updated_at: Time.now) }

    it { is_expected.to have_been_updated_recently }

    context "updated too long ago" do
      subject { FactoryGirl.create(:organisation, updated_at: 1.year.ago)}
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
  
  describe 'friendly_id' do
    # TODO: more tests on friendly_id methods?
    it 'should use short_name as slug as first' do
      org = FactoryGirl.create(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great')
    end
    
    it 'should use prolonged_name as slug as second' do
      FactoryGirl.create(:friendly_id_org)
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great-charity-london')
    end
    
    it 'should use orged as slug as third' do
      2.times { FactoryGirl.create(:friendly_id_org) }
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('most-noble-great-charity-london-org')
    end
    
    it 'should use full name as slug as fourth' do
      3.times { FactoryGirl.create(:friendly_id_org) }
      org = FactoryGirl.build(:friendly_id_org)
      expect(org.slug).to eq('the-most-noble-great-charity-of-london')
    end
    
    it 'should use special name for parochial churches' do
      org = FactoryGirl.create(:parochial_org)
      expect(org.slug).to eq('parochial-church-st-alban-north')
    end
  
  end

end
