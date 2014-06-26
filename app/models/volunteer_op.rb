class VolunteerOp < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :description, :title, :organization_id
  validates_presence_of :title, :organization_id
end
