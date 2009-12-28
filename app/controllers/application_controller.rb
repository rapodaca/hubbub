# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :login, :current_user, :article_permalink_url
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
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = login && login.user
  end
  
  # From auth_logic tutorial
  def login
    return @login if defined?(@login)
    @login = UserSession.find
  end
  
  def article_permalink_url article
    time = article.created_at
    articles_url + "/#{time.year}/#{time.month}/#{time.day}/#{article.slug}"
  end
end
