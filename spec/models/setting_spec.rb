require 'rails_helper'

RSpec.describe Setting, type: :model do

  context '#latitude' do
    it 'should have a default latitude' do
      expect(Setting.latitude).to eq '51.5978'
    end
    it 'should accept an latitude override' do
      Setting.create(key: 'latitude', value: '51.4959297')
      expect(Setting.latitude).to eq '51.4959297'
    end
  end
  context '#longitude' do
    it 'should have a default longitude' do
      expect(Setting.longitude).to eq '-0.3370'
    end
    it 'should accept an longitude override' do
      Setting.create(key: 'longitude', value: '-0.2100279')
      expect(Setting.longitude).to eq '-0.2100279'
    end
  end
  context '#meta_tag_title' do
    it 'should have a default meta tag title' do
      expect(Setting.meta_tag_title).to eq 'Harrow Community Network'
    end
    it 'should accept an meta tag title override' do
      Setting.create(key: 'meta_tag_title', value: 'KSCS Community Assets')
      expect(Setting.meta_tag_title).to eq 'KSCS Community Assets'
    end
  end

end
