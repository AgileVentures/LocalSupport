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
                 
  def self.search(keyword) 
    keyword = "%#{keyword}%"
    where(contains_description?(keyword).or(contains_title?(keyword)))
  end

  def all_day_event?
    self.start_date == self.start_date.midnight && self.end_date == self.end_date.midnight
  end

  def self.table
    arel_table
  end

  def self.contains_description?(key)
    table[:description].matches(key)
  end

  def self.contains_title?(key)
    table[:title].matches(key)
  end

end
