class DescriptionHumanizer

  def self.call(description)
    description.nil? ? '' : description.humanize
  end

end
