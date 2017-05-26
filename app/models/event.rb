class Event < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  scope :upcoming, lambda { |n| 
                               where('start_date > ?', DateTime.current)
                              .order('created_at DESC')
                              .limit(n) 
                   }

end
