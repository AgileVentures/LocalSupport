require 'rails_helper'

# Example:
# This will leave items uncleaned in the db but rspec has no complaint about syntax
# FactoryGirl.create(:organisation, name: 'fiendish-bare', address: nil, postcode: nil)

# Example:
# If the only contents of this file, it will not be run because it has no it block 'examples'
# describe 'database cleaner' do
#   # before :each aka before gets cleaned up, before :all does not
#   before :all do
#     FactoryGirl.create(:organisation, name: 'fiendish-all', address: nil, postcode: nil)
#   end
# end

describe 'database cleaner' do
  # before :each aka before gets cleaned up, before :all does not
  before :each do
    FactoryGirl.create(:organisation, name: 'fiendish-all')
  end
  it 'it block gets cleaned up' do
    FactoryGirl.create(:organisation, name: 'fiendish-it')
  end
  describe 'inner describe' do
    it 'with it block cleaned up too' do
      FactoryGirl.create(:organisation, name: 'fiendish-inner')
    end
  end
end


