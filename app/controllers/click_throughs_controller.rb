class ClickThroughsController < ApplicationController
  def go_to
    click_through = ClickThrough.new
    if user_signed_in?
      click_through.user_id = current_user.id
    end
    click_through.source_url = request.headers['HTTP_REFERER']

    if params[:url].nil?
      click_through.url = '#'
    else
      click_through.url = params[:url]
    end
    click_through.save
    redirect_to params[:url]
  end
end