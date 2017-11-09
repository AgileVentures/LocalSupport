class DoitTrace < ActiveRecord::Base

  def self.add_entry(volunteer_op_id, doit_volop_id)
    create(published_at: Time.zone.now,
           doit_volop_id: doit_volop_id,
           volunteer_op_id: volunteer_op_id)
  end

  def self.published?(volunteer_op_id)
    find_by(volunteer_op_id: volunteer_op_id)
  end

  def self.local_origin?(doit_volop_id)
    find_by(doit_volop_id: doit_volop_id)
  end
end
