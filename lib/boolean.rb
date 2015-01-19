module Boolean
  def self.from(value)
    [
      '1',
      1,
      'y',
      'yes',
      't',
      'true',
      true
    ].include? (value.try(:downcase) || value)
  end
end

