class ErrorsController < ApplicationController

  def not_found
    debugger
    render :status => 404
  end

  def unacceptable
    render :status => 422
  end

  def internal_error
    render :status => 500
  end

end
