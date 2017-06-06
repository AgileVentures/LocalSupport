require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe DoitTrace, type: :model do
  describe '.add_entry' do
    it 'add a new trace entry with current datetime' do
      current_time = Time.new(2017,3,11,00,00,00)
      org = create(:organisation)
      volunteer_op = create(:volunteer_op, organisation: org)
      travel_to current_time do
        trace = DoitTrace.add_entry(volunteer_op.id)

        expect(trace.published_at).to eq(current_time)
        expect(trace.volunteer_op_id).to eq(volunteer_op.id)
      end
    end
  end

  describe '.published?' do
    it 'return true if a volunteer op was published to Doit' do
      org = create(:organisation)
      volunteer_op = create(:volunteer_op, organisation: org)
      DoitTrace.create(volunteer_op_id: volunteer_op.id,
                       published_at: Time.zone.now)

      expect(DoitTrace.published?(volunteer_op.id)).to be_truthy
    end

    it 'returns false if a volunteer op was not published' do
      expect(DoitTrace.published?(5)).to be_falsey
    end
  end
end
