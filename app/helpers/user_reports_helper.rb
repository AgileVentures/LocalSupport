module UserReportsHelper
  def time_ago_in_words_with_nils(time)
    if time.nil?
     'never'
    else
      time_ago_in_words(time) + ' ago'
    end
  end
end