require 'spec_helper'

describe HomeController do
  def mock_article
    @article = mock_model(Article)
  end
  
  def find_recent_articles
    mock_article
    @recent_articles  = [@article, @article]
    Article.stub!(:find).and_return @recent_articles
  end
  
  describe "GET index" do
    before(:each) do
      find_recent_articles
    end
    it "assigns recent_articles" do
      get :index
      assigns[:recent_articles].should == @recent_articles
    end
  end
end
