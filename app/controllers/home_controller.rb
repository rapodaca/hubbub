class HomeController < ApplicationController
  def index
    @article = Article.last
  end
end
