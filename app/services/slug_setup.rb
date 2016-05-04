class SlugSetup
    
    attr_reader :name 

    def self.setup(name)
        new(name).send(:candidates)
    end

    def initialize(name)
        @name = name
    end
    
    def candidates
        [   @name.method(:short_name), 
            @name.method(:prolonged_name), 
            @name.method(:orged), 
            :name
        ]
    end
    
end

class String
    
    NOT_WANTED = %w(the of for and in to)

    def short_name
        slug_words.first(3).join('-')
    end

    def prolonged_name
        "#{short_name}-#{slug_words[-2]}-#{slug_words[-1]}"
    end

    def orged
        "#{slug_words.join('-')}-org"
    end

    def slug_words
        words = "#{self}".delete('\'','-').scan(/\b\w+\b/).map(&:downcase)
        words.reject {|w| NOT_WANTED.include?(w) }
    end
    
end

