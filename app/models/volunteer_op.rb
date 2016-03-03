class VolunteerOp < ActiveRecord::Base
  validates :title, :description, presence: true
  validates :organisation_id, presence: true, if: "source == 'local'"
  belongs_to :organisation

  scope :order_by_most_recent, -> { order('updated_at DESC') }
  scope :local_only, -> { where(source: 'local') }

  def organisation_name

  end

  def organisation_link

  end
end
