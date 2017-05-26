class Event < ActiveRecord::Base
  validates_presence_of :title, :description, :start_date, :end_date
  scope :upcoming, -> (n) { 
                             where('start_date > ?', DateTime.current)
                            .order('created_at DESC')
                            .limit(n) 
                          }

end
