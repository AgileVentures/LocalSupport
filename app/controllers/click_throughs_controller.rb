class ClickThroughsController < ApplicationController
  def go_to
    user_id = current_user.id if user_signed_in?
    source_url = request.headers['HTTP_REFERER']
    url = params[:url].nil? ? '#' : params[:url]
    ClickThrough.create(user_id: user_id, source_url: source_url, url: url)
    redirect_to url
  end
end