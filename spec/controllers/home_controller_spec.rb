require 'spec_helper'

describe HomeController do
  def mock_article
    @article = mock_model(Article)
  end
  
  def find_article
    mock_article
    Article.stub!(:find).and_return(@article)
  end
  
  def find_recent_articles
    @recent_articles  = [@article, mock_model(Article)]
    Article.stub!(:find_recent).and_return @recent_articles
  end
  
  describe "GET index" do
    before(:each) do
      find_article
      find_recent_articles
    end
    it "finds the last article" do
      Article.should_receive(:last).and_return @article
      get :index
    end
    it "assigns article" do
      get :index
      assigns[:article].should == @article
    end
    it "assigns recent_articles" do
      get :index
      assigns[:recent_articles].should == [@recent_articles.last]
    end
  end
end
