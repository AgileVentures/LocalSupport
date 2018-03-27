class StartDateValidator < ActiveModel::Validator
  def validate(record)
    if  record.start_date > record.end_date
      record.errors[:start_date] << 'Start date must come after End date'
    end
    if record.start_date < Time.zone.now
      record.errors[:start_date] << 'Start Date Cannot be in the past'
    end
    if record.end_date < Time.zone.now
      record.errors[:end_date] << 'End Date Cannot be in the past'
    end
  end
end


