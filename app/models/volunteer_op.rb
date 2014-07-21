class VolunteerOp < ActiveRecord::Base
  validates :title, :description, :organization_id, presence: true
  belongs_to :organization

  attr_accessible :description, :title, :organization_id
end
