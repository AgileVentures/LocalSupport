class ClickThroughsController < ApplicationController
  def go_to
    click_through = ClickThrough.new
    click_through.user_id = current_user.id if user_signed_in?
    click_through.source_url = request.headers['HTTP_REFERER']
    click_through.url = params[:url].nil? ? '#' : params[:url]
    click_through.save

    redirect_to click_through.url
  end
end