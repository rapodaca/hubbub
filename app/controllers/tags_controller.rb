class TagsController < ApplicationController
  def index
    @tags = Tag.find :all, :order => 'slug ASC'
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @tag = Tag.find_by_slug! params[:id]
    @articles = @tag.recent_articles params[:page]
  end

  def update
    @tag = Tag.find_by_slug! params[:id]
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "Tag updated."
      redirect_to tag_url(@tag)
    else
      render :action => 'edit', :status => :unprocessable_entity
    end
  end

  def edit
    @tag = Tag.find_by_slug! params[:id]
  end

  def destroy
    tag = Tag.find_by_slug! params[:id]
    tag.destroy
    flash[:notice] = "Tag destroyed."
    redirect_to tags_url
  end
end
