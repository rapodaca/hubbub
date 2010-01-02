class HomeController < ApplicationController
  def index
    @recent_articles = Article.find :all,
                                    :order => 'created_at DESC',
                                    :limit => 5
  end
end
