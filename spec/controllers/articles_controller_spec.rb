require 'spec_helper'

describe ArticlesController do
  def mock_article
    @article = mock_model(Article)
    Article.stub!(:find_recent).and_return [@article]
  end
  
  def do_index mime=nil
    request.env['HTTP_ACCEPT'] = mime unless mime.blank?
    get :index
  end
  describe "GET index" do
    before(:each) do
      mock_article
    end
    describe "with html" do
      it "responds OK" do
        do_index
        response.response_code.should == 200
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
          response.should redirect_to Hubbub::Config[:publisher][:redirect]
        end
      end
    end
  end
end
