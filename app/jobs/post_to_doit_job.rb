class PostToDoitJob < ActiveJob::Base
  queue_as :default

  def perform(options, doit_post_handler = Doit::PostToDoit, trace_handler = DoitTrace)
    volunteer_op = options.fetch(:volunteer_op)
    doit_volop_id = doit_post_handler.call(volunteer_op: volunteer_op,
                           advertise_start_date: options.fetch(:advertise_start_date),
                           advertise_end_date: options.fetch(:advertise_end_date),
                           doit_org_id: options.fetch(:doit_org_id)
                          )
    trace_handler.add_entry(volunteer_op.id, doit_volop_id)
  end
end
