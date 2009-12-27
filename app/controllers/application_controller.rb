# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  
  protected
  
  def feed_publisher_request?
    Hubbub::Config[:publisher] && Hubbub::Config[:publisher][:user_agent] &&
    request.env['HTTP_USER_AGENT'].include?(Hubbub::Config[:publisher][:user_agent])
  end
  
  def feed_publisher_url
    Hubbub::Config[:publisher][:redirect]
  end
end
