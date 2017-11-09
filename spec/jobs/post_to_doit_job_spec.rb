require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe PostToDoitJob, type: :job do
  describe '#perform' do
    it 'execute post to doit service' do
      trace_double = double(add_entry: true)
      allow(Doit::PostToDoit).to receive(:call)

      PostToDoitJob.new.perform(
                                {volunteer_op: double(id: 2),
                                 advertise_start_date: nil,
                                 advertise_end_date: nil,
                                 doit_org_id: nil
                                },
                                Doit::PostToDoit,
                                trace_double
                                 )

      expect(Doit::PostToDoit).to have_received(:call)
      expect(trace_double).to have_received(:add_entry)
    end
  end
end
