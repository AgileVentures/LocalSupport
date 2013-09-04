class FirstCapitalsHumanizer
  def self.call(phrase)
    phrase.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
