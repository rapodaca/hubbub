require 'spec_helper'

describe ArticlesController do
  def mock_article
    @article = mock_model(Article, :created_at => Time.now, :slug => 'foo')
  end
  
  def new_article
    Article.stub!(:new).and_return @article
  end
  
  def find_recent
    Article.stub!(:find_recent).and_return [@article]
  end
  
  def find_by_permalink
    Article.stub!(:find_by_permalink).and_return @article
  end
  
  def find_article
    Article.stub!(:find).and_return @article
  end
  
  def do_index mime=nil
    request.env['HTTP_ACCEPT'] = mime unless mime.blank?
    get :index
  end
  
  def article_permalink_url article
    time = article.created_at
    articles_url + "/#{time.year}/#{time.month}/#{time.day}/#{article.slug}"
  end
  
  def do_create; post :create, :article => {}; end
  def do_show; get :show, :id => @article.id; end
  def do_new; get :new; end
  def do_update; put :update, :id => @article.id; end
  def do_edit; get :edit, :id => @article.id; end
  def do_destroy; delete :destroy, :id => @article.id; end
  
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
  
  describe "POST create" do
    before(:each) do
      mock_article
      new_article
    end
    describe "when successful" do
      before(:each) do
        @article.stub!(:save).and_return true
      end
      it "flashes success" do
        do_create
        flash[:success].should_not be_blank
      end
      it "redirects to article permalink url" do
        do_create
        response.should redirect_to(article_permalink_url(@article))
      end
    end
    describe "when unsuccessful" do
      before(:each) do
        @article.stub!(:save).and_return false
      end
      it "renders new" do
        do_create
        response.should render_template(:new)
      end
      it "returns unprocessable" do
        do_create
        response.response_code.should == 422
      end
    end
  end
  
  describe "GET new" do
    before(:each) do
      mock_article
      new_article
    end
    it "assigns article" do
      do_new
      assigns[:article].should == @article
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
  
  describe "PUT update" do
    before(:each) do
      mock_article
      find_article
    end
    describe "when successful" do
      before(:each) do
        @article.stub!(:update_attributes).and_return true
      end
      it "redirects to article url" do
        do_update
        response.should redirect_to(article_url(@article))
      end
      it "flashes success" do
        do_update
        flash[:success].should_not be_blank
      end
    end
    describe "when unsuccessful" do
      before(:each) do
        @article.stub!(:update_attributes).and_return false
      end
      it "renders edit" do
        do_update
        response.should render_template(:edit)
      end
      it "returns unprocessable entity" do
        do_update
        response.response_code.should == 422
      end
    end
  end
  
  describe "GET edit" do
    before(:each) do
      mock_article
      find_article
    end
    it "assigns article" do
      do_edit
      assigns[:article].should == @article
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      mock_article
      @article.stub!(:destroy).and_return(true)
      find_article
    end
    it "redirects to articles url" do
      do_destroy
      response.should redirect_to(articles_url)
    end
    it "destroys article" do
      @article.should_receive(:destroy)
      do_destroy
    end
    it "flashes success" do
      do_destroy
      flash[:success].should_not be_blank
    end
  end
end
