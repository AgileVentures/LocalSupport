require 'rails_helper'

describe Location, type: :model do

  describe '#==' do
    context 'equal objects' do
      it 'returns true' do
        l1 = Location.new(longitude: 10, latitude: 15)
        l2 = Location.new(longitude: 10, latitude: 15)
        expect(l1 == l2).to eq(true)
      end
    end

    context 'not equal objects' do
      it 'returns false' do
        l1 = Location.new(longitude: 10, latitude: 15)
        l2 = Location.new(longitude: 17, latitude: 45)
        expect(l1 == l2).to eq(false)
      end
    end
  end

  describe '.build_hash' do
    it 'create location object from hash keys' do
      vol_op1 = build(:volunteer_op)
      vol_op2 = build(:doit_volunteer_op)
      vol_op3 = build(:volunteer_op)
      input = { 
        [12.0, 30.0] => [vol_op1],
        [15.0, 45.0] => [vol_op2, vol_op3],
        [80.0, 25.0] => [vol_op2]
      }

      expect(Location.build_hash(input)).to eq({
        Location.new(longitude: 12.0, latitude: 30.0) => [vol_op1],
        Location.new(longitude: 15.0, latitude: 45.0) => [vol_op2, vol_op3],
        Location.new(longitude: 80.0, latitude: 25.0) => [vol_op2]
      })
    end
  end
end
