require 'spec_helper'

describe Feature do
  describe '::activate' do
    it 'sets ::active? from true to true' do
      Feature.create(:foo, true)
      Feature.activate(:foo)
      expect(Feature.active?(:foo)).to be true
    end
    it 'sets ::active? from false to true' do
      Feature.create(:foo, false)
      Feature.activate(:foo)
      expect(Feature.active?(:foo)).to be true
    end
  end

  describe '::deactivate' do
    it 'sets ::active? from true to false' do
      Feature.create(:foo, true)
      Feature.deactivate(:foo)
      expect(Feature.active?(:foo)).to be false
    end
    it 'sets ::active? from false to false' do
      Feature.create(:foo, false)
      Feature.deactivate(:foo)
      expect(Feature.active?(:foo)).to be false
    end
  end

  describe '::active?' do
    it 'is false when inactive' do
      Feature.create(:foo, false)
      expect(Feature.active?(:foo)).to be false
    end
    it 'is true when active' do
      Feature.create(:foo, true)
      expect(Feature.active?(:foo)).to be true
    end
  end
end
