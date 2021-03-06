class PagesController < ApplicationController
  before_filter :require_user, :only => [:create, :new, :update, :edit, :destroy]
  
  make_resourceful do
    actions :all
  end
  
  private
  
  def current_objects
    Page.find(:all, :order => 'created_at DESC')
  end
  
  def current_object
    @current_object ||= Page.find_by_title_slug! params[:id]
  end
end
