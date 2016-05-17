class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
  
  # Methods below created to customly setup slugs from friendly_id gem
  
  def short_name
    if self.match(/parochial church/i)
      parochial_churches
    else
      slug_words.first(3).join('-')
    end
  end

  def longer_name
    "#{short_name}-#{slug_words[-2]}-#{slug_words[-1]}"
  end

  def append_org
    "#{slug_words.join('-')}-org"
  end
  
  NOT_WANTED = %w(the of for and in to)
  
  private
  
  def slug_words
    words = "#{self}".delete('\'', '-').downcase_words
    words.reject { |w| NOT_WANTED.include?(w) }
  end

  def parochial_churches
    return slug_words.first(2).push(parish.downcase_words.first(3)).join('-') unless parish.nil?
    longer_name
  end
  
  def parish
    self.slice(/(?<=parish of )(.+)\z/i)
  end

  def downcase_words
    self.scan(/\b\w+\b/).map(&:downcase)
  end
  
end