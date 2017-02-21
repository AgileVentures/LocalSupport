require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe PostToDoitJob, type: :job do
  describe '#perform' do
    it 'execute post to doit service' do
      allow(Doit::PostToDoit).to receive(:call)

      PostToDoitJob.new.perform(volunteer_op: nil,
                                 advertise_start_date: nil,
                                 advertise_end_date: nil,
                                 doit_org_id: nil
                                 )

      expect(Doit::PostToDoit).to have_received(:call)
    end
  end
end
