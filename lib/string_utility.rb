module StringUtility

  # from http://stackoverflow.com/questions/1293573/rails-smart-text-truncation
  def smart_truncate(sentence, char_limit = 128)
    sentence = sentence.to_s
    size = 0
    sentence.split.reject do |word|
      size += word.size
      size > char_limit
    end.join(' ')+ending(sentence, char_limit)
  end

  def ending(sentence, char_limit)
    sentence.size > char_limit ? ' '+ '...' : ''
  end
end
