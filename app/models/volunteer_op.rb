class VolunteerOp < ActiveRecord::Base
  validates :title, :description, :organisation_id, presence: true
  belongs_to :organisation

  scope :order_by_most_recent, ->{order('updated_at DESC')}

  #attr_accessible :description, :title, :organisation_id
end
