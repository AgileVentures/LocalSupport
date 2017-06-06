class DoitTrace < ActiveRecord::Base
  belongs_to :volunteer_op

  def self.add_entry(volunteer_op_id)
    create(published_at: Time.zone.now, volunteer_op_id: volunteer_op_id)
  end

  def self.published?(volunteer_op_id)
    !(where(volunteer_op_id: volunteer_op_id).blank?)
  end
end
