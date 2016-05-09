class SetupSlug

  attr_reader :name 

  def self.run(name)
    new(name).send(:candidates)
  end

  def initialize(name)
    @name = name
  end
    
  def candidates
    [ name.method(:short_name), 
      name.method(:longer_name), 
      name.method(:append_org), 
      :name
    ]
  end
    
end

class String
    
  NOT_WANTED = %w(the of for and in to)

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

  def slug_words
    words = "#{self}".delete('\'','-').downcase_words
    words.reject {|w| NOT_WANTED.include?(w) }
  end
    
  def parochial_churches
    parish = self.slice(/(?<=parish of )(.+)\z/i).downcase_words
    slug_words.first(2).push(parish.first(3)).join('-')
  end
    
  def downcase_words
    self.scan(/\b\w+\b/).map(&:downcase)
  end
    
end

