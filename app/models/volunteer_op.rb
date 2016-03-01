class VolunteerOp < ActiveRecord::Base
  validates :title, :description, :organisation_id, presence: true
  belongs_to :organisation

  scope :order_by_most_recent, -> { order('updated_at DESC') }
  scope :local_only, -> { where(source: 'local') }

  after_create -> { if latitude.nil? ; delegate :latitude, :to => :organisation ; end }
  after_create -> { if longitude.nil? ; delegate :longitude, :to => :organisation ; end }

end
