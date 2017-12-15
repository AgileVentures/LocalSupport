require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe VolunteerOpForm do
  describe '#save' do
    context 'with post to doit flag' do
      it 'publish volunteer op to doit' do
        ActiveJob::Base.queue_adapter = :test
        org = create(:organisation)
        input_params = {
            'title'=>'test007-001',
            'description'=>'description for 007',
            'address'=>'1234',
            'postcode'=>'HA1 3UJ',
            'post_to_doit'=>'1',
            'advertise_start_date'=>'',
            'advertise_end_date'=>'',
            'organisation_id' => org.id
        }
        doit_volunteer_op = VolunteerOpForm.new(input_params)
        allow(doit_volunteer_op).to receive(:valid?).and_return(true)
        doit_volunteer_op.save
        expect {PostToDoitJob.perform_later}.to have_enqueued_job(PostToDoitJob)
      end
    end
  end
end
