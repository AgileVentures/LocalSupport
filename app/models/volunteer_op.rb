class VolunteerOp < ActiveRecord::Base
  validates :title, :description, :organisation_id, presence: true
  belongs_to :organisation

  scope :order_by_most_recent, -> { order('updated_at DESC') }
  scope :local_only, -> { where(source: 'local') }

  after_create do
    if latitude.nil?
      instance_eval(%Q(
       def latitude
         organisation.latitude
       end
      ))
    end
  end
  after_create do
    if longitude.nil?
      instance_eval(%Q(
        def longitude
          organisation.longitude
        end
      ))
    end
  end

end
