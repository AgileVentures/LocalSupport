class StartDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if  value.start_date > value.end_date
      record.errors[attribute] << 'Start date must come after End date'
    elsif 
      value.start_date > Time.zone.now
      record.errors[attribute] << 'Start Date Cannot be in the past'
    elsif 
      value.end_date > Time.zone.now
      record.errors[attribute] << 'End Date Cannot be in the past'
    end

  end
end


