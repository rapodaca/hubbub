class UserSessionsController < ApplicationController
  layout 'login'
  
  def create
    @user_session = UserSession.new params[:user_session]
    
    @user_session.save do |result|
      if result
        flash[:success] = "Welcome back"
        
        redirect_to root_url
      else
        render :action => :new
      end
    end
  end

  def new
    @user_session = UserSession.new
  end

  def destroy
    if login
      login.destroy
      flash[:success] = "You are now logged out."
    else
      flash[:warning] = "You are already logged out."
    end
    
    redirect_to root_url
  end
end
