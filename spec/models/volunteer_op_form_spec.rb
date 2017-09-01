require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe VolunteerOpForm do

  describe '#save' do
    context 'with post to doit flag' do
      it 'publish volunteer op to doit' do
        org = create(:organisation)

        input_params = {"title"=>"test007-001",
                         "description"=>"description for 007",
                         "address"=>"1234",
                         "postcode"=>"HA1 3UJ",
                         "post_to_doit"=>"1",
                         "advertise_start_date"=>"",
                         "advertise_end_date"=>"",
                         "organisation_id" => org.id}
        trace_double = double(add_entry: true)
        doit_volunteer_op = VolunteerOpForm.new(input_params)
        allow(doit_volunteer_op).to receive(:valid?).and_return(true)
        allow_any_instance_of(VolunteerOpForm).to receive(:trace_handler).
          and_return(trace_double)
        allow(PostToDoitJob).to receive(:perform_later)

        doit_volunteer_op.save

        expect(PostToDoitJob).to have_received(:perform_later)
        expect(trace_double).to have_received(:add_entry)
      end
    end
  end
end
