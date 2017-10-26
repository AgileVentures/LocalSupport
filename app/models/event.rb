class Event < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  scope :upcoming, lambda { |n|
                               where('start_date > ?', DateTime.current.midnight)
                              .order('created_at DESC')
                              .limit(n)
                   }

  def all_day_event?
    self.start_date == self.start_date.midnight && self.end_date == self.end_date.midnight
  end
end
