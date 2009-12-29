class TagsController < ApplicationController
  def index
    @tags = Tag.find :all, :order => 'slug ASC'
  end

  def show
    @tag = Tag.find_by_slug! params[:id]
    @articles = @tag.recent_articles params[:page]
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
