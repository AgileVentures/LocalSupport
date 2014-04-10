class VolunteerOp < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :description, :title
end
