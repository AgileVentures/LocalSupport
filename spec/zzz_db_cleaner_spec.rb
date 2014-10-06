require 'spec_helper'

describe 'database cleaner' do
  # before :each aka before gets cleaned up, before :all does not
  # if no examples to run, test is not executed
  before :all do
    FactoryGirl.create(:organisation, name: 'fiendish-all', address: nil, postcode: nil)
  end
  it 'it block gets cleaned up' do
    FactoryGirl.create(:organisation, name: 'fiendish-it', address: nil, postcode: nil)
  end
  describe 'inner describe' do
    it 'with it block cleaned up too' do
      FactoryGirl.create(:organisation, name: 'fiendish-inner', address: nil, postcode: nil)
    end
  end
end


