class TagsController < ApplicationController
  make_resourceful do
    actions :index, :update, :edit, :destroy
  end
  
  def show
    @tag = Tag.find_by_slug! params[:id]
    @articles = @tag.recent_articles params[:page]
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end
  
  private
  
  def current_objects
    Tag.find :all, :order => 'slug ASC'
  end
  
  def current_object
    @current_object ||= Tag.find_by_slug!(params[:id])
  end
end
