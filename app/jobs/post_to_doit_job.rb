class PostToDoitJob < ActiveJob::Base
  queue_as :default

  def perform(options, doit_post_handler = Doit::PostToDoit)
    doit_post_handler.call(volunteer_op: options.fetch(:volunteer_op),
                           advertise_start_date: options.fetch(:advertise_start_date),
                           advertise_end_date: options.fetch(:advertise_end_date),
                           doit_org_id: options.fetch(:doit_org_id)
                          )
  end
end
