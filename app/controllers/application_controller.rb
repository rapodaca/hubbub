# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :login, :current_user, :article_permalink_url
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # alias_method :rescue_action_locally, :rescue_action_in_public
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  
  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end
  
  # See: http://henrik.nyh.se/2008/07/rails-404
  def render_404
    respond_to do |type| 
      type.html { render :template => "errors/error_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true  # so we can do "render_404 and return"
  end
  
  def feed_publisher_request?
    logger.info "Feed Publisher Request?"
    Hubbub::Config[:publisher] && Hubbub::Config[:publisher][:user_agent] &&
    request.env['HTTP_USER_AGENT'].include?(Hubbub::Config[:publisher][:user_agent])
  end
  
  def feed_publisher_url
    Hubbub::Config[:publisher][:redirect]
  end
  
  def require_user
    unless current_user
      store_location
      flash[:warning] = "Please login or create an account first."
      redirect_to '/login'
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = login && login.user
  end
  
  # From auth_logic tutorial
  def login
    return @login if defined?(@login)
    begin
      @login = UserSession.find
    rescue
    end
  end
  
  def article_permalink_url article
    time = article.created_at
    articles_url + "/#{time.year}/#{"%02d" % time.month}/#{"%02d" % time.day}/#{article.title_slug}"
  end
end
