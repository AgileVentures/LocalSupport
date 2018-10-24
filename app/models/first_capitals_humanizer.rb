class FirstCapitalsHumanizer
  def self.call(phrase)
    phrase.humanize.split(' ').map(&:capitalize).join(' ')
  end
end
