require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe DoitVolunteerOp do
  it { should validate_presence_of(:volunteer_op) }
  it { should validate_presence_of(:advertise_start_date) }
  it { should validate_presence_of(:advertise_end_date) }
  it { should validate_presence_of(:doit_org_id) }

  describe '#save' do
    it 'publish volunteer op to doit' do
      trace_handler = double(add_entry: true)
      doit_volunteer_op = DoitVolunteerOp.new(volunteer_op: double(id: 1))
      allow(doit_volunteer_op).to receive(:valid?).and_return(true)
      allow(PostToDoitJob).to receive(:perform_later)

      doit_volunteer_op.save(trace_handler: trace_handler)

      expect(PostToDoitJob).to have_received(:perform_later)
      expect(trace_handler).to have_received(:add_entry)
    end
  end
end
