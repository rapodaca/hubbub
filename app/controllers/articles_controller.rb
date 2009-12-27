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
    @article = Article.new(params[:article])
    
    if @article.save
      flash[:success] = "Created article."
      redirect_to(article_url(@article))
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find_by_permalink params
  end

  def update
    @article = Article.find_by_permalink params
    
    if @article.update_attributes(params[:article])
      flash[:success] = "Article updated."
      redirect_to article_url(@article)
    else
      render :action => 'edit', :status => :unprocessable_entity
    end
  end

  def edit
    @article = Article.find_by_permalink params
  end

  def destroy
    article = Article.find_by_permalink params
    article.destroy
    flash[:success] = "Article destroyed."
    redirect_to articles_url
  end
end
