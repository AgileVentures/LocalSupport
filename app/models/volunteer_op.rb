class VolunteerOp < ActiveRecord::Base
  validates :title, :description, :organisation_id, presence: true
  belongs_to :organisation

  attr_accessible :description, :title, :organisation_id
end
