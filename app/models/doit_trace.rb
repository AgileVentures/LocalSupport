# == Schema Information
#
# Table name: doit_traces
#
#  id              :integer          not null, primary key
#  published_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  doit_volop_id   :string
#  volunteer_op_id :integer
#
# Indexes
#
#  index_doit_traces_on_doit_volop_id    (doit_volop_id)
#  index_doit_traces_on_volunteer_op_id  (volunteer_op_id)
#
# Foreign Keys
#
#  fk_rails_...  (volunteer_op_id => volunteer_ops.id)
#

class DoitTrace < ApplicationRecord

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
