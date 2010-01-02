class TagsController < ApplicationController
  before_filter :require_user, :only => [:update, :edit, :destroy]
  
  make_resourceful do
    actions :index, :update, :edit, :destroy
  end
  
  def show
    @tag = Tag.find_by_slug! params[:id]
    # @articles = @tag.recent_articles params[:page]
    respond_to do |format|
      format.html do
        @articles = @tag.page_articles params[:page]
      end
      format.atom do
        @articles = @tag.feed_articles
        render :layout => false
      end
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
