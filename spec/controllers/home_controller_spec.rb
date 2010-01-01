require 'spec_helper'

describe HomeController do
  def mock_article
    @article = mock_model(Article)
  end
  
  def find_article
    mock_article
    Article.stub!(:find).and_return(@article)
  end
  
  describe "GET index" do
    before(:each) do
      find_article
    end
    it "finds the last article" do
      Article.should_receive(:last).and_return @article
      get :index
    end
    it "assigns article" do
      get :index
      assigns[:article].should == @article
    end
  end
end
