class ArticlesController < ApplicationController
  def index
    respond_to do |format|
      @articles = Article.find_recent(:page => params[:page])
      
      format.html
      format.atom do
        if feed_publisher_request?
          redirect_to feed_publisher_url
        else
          render :layout => false
        end
      end
    end
  end

  def create
  end

  def new
  end

  def show
    @article = Article.find_by_permalink params
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
