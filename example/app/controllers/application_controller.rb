class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def status
    sleep 0.200
    render json: { status: 'okay' }
  end
end
