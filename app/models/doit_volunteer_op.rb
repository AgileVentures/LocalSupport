class DoitVolunteerOp
  include ActiveModel::Model

  attr_accessor :advertise_start_date, :advertise_end_date, :doit_org_id,
    :volunteer_op

  validates :volunteer_op, presence: true
  validates :advertise_start_date, presence: true
  validates :advertise_end_date, presence: true
  validates :doit_org_id, presence: true

  def save(trace_handler:)
    if valid?
      PostToDoitJob.perform_later(build_options)
      trace_handler.add_entry(volunteer_op.id)
      true
    else
      false
    end
  end

  private

  def build_options
    {
      volunteer_op: volunteer_op,
      advertise_start_date: advertise_start_date,
      advertise_end_date: advertise_end_date,
      doit_org_id: doit_org_id
    }
  end
end
