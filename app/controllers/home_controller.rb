class HomeController < ApplicationController
  def index
    @article = Article.last
    @recent_articles = Article.find_recent :per_page => 6
    @recent_articles.shift
  end
end
