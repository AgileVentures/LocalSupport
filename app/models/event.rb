class Event < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_presence_of :id, allow_nil: true
  validates_presence_of :postal, allow_nil: true
  validate :organisation_xor_postal
  scope :upcoming, lambda { |n|
                               where('start_date > ?', DateTime.current.midnight)
                              .order('created_at DESC')
                              .limit(n)
                   }

  def all_day_event?
    self.start_date == self.start_date.midnight && self.end_date == self.end_date.midnight
  end

  private

    def organisation_xor_postal
      unless organisation.blank? ^ postal.blank?
        errors.add(:address, "Specify an organisation or a postal code, not both")
      end
    end
end
