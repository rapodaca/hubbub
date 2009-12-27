require 'spec_helper'

describe ArticlesController do
  def mock_article
    @article = mock_model(Article)
  end
  
  def find_recent
    Article.stub!(:find_recent).and_return [@article]
  end
  
  def find_by_permalink
    Article.stub!(:find_by_permalink).and_return @article
  end
  
  def do_index mime=nil
    request.env['HTTP_ACCEPT'] = mime unless mime.blank?
    get :index
  end
  
  def do_show
    get :show
  end
  
  describe "GET index" do
    before(:each) do
      mock_article
      find_recent
    end
    describe "with html" do
      it "succeeds" do
        do_index
        response.should be_success
      end
      it "assigns articles" do
        do_index
        assigns[:articles].should == [@article]
      end
    end
    describe "with atom" do
      describe "response content type" do
        it "is atom" do
          do_index 'application/atom+xml'
          response.content_type.should == 'application/atom+xml'
        end
      end
      describe "as feed publisher" do
        before(:each) do
          Hubbub::Config.stub!(:[]).with(:publisher).and_return({
            :redirect   => 'http://feedburner.com',
            :user_agent => 'FeedBurner'
          })
          request.env['HTTP_USER_AGENT'] = 'FeedBurner 1.0'
        end
        it "redirects" do
          do_index 'application/atom+xml'
          response.should redirect_to(Hubbub::Config[:publisher][:redirect])
        end
      end
    end
  end
  
  describe "GET show" do
    before(:each) do
      mock_article
      find_by_permalink
    end
    it "succeeds" do
      do_show
      response.should be_success
    end
    it "assigns article" do
      do_show
      assigns[:article].should == @article
    end
  end
end
