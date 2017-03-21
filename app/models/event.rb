class Event < ActiveRecord::Base
  validates_presence_of :title, :description, :start_date, :end_date
end
