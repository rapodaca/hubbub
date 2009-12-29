class PagesController < ApplicationController
  make_resourceful do
    actions :all
    
    after :create do
      flash[:success] = "Created page."
    end
  end
  
  private
  
  def current_objects
    Page.find(:all, :order => 'created_at DESC')
  end
  
  def current_object
    @current_object ||= Page.find_by_title_slug! params[:id]
  end
end
