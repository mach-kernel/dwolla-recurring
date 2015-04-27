class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?

  # Very simple session management. We don't need anything fancy.
  def logged_in?
  	session.has_key?(:oauth_token)
  end

end
