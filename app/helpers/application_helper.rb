module ApplicationHelper
  # from http://stackoverflow.com/questions/1293573/rails-smart-text-truncation
  def smart_truncate(sentence, char_limit = 128)
      sentence = sentence.to_s
      size =0
      sentence.split().reject do |word|
        size+=word.size()
        size>char_limit
      end.join(" ")+(sentence.size()>char_limit ? " "+ "..." : "" )
  end

  def markdown(text)
    red_carpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
    red_carpet.render(text).html_safe
  end

  # Withholding this functionality until we decide how to implement an admin 'dashboard'

  ## http://railscasts.com/episodes/20-restricting-access
  #def authorize
  #  unless admin?
  #    flash[:error] = 'unauthorized access'
  #    redirect_to '/'
  #    false
  #  end
  #end
  #
  ## Not to be confused with the activerecord admin? method
  #def admin?
  #  current_user.present? ? current_user.admin? : false
  #end
end


