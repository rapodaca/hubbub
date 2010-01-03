require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/shared/protected_controller_spec')

describe ArticlesController do
  def mock_article
    @article = mock_model(Article,
      :created_at => Time.now, :title_slug => 'foo', :user= => true)
  end
  
  def new_article
    Article.stub!(:new).and_return @article
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
  
  def page_items
    mock_article
    Article.stub!(:page_items).and_return [@article]
  end
  
  def feed_items
    mock_article
    Article.stub!(:feed_items).and_return [@article]
  end
  
  def article_permalink_url article
    time = article.created_at
    articles_url + "/#{time.year}/#{"%02d" % time.month}/#{"%02d" % time.day}/#{article.title_slug}"
  end
  
  def login
    @user = mock_model(User)
    @user_session = mock_model(UserSession, :user => @user)
    UserSession.stub!(:find).and_return @user_session
  end
  
  def do_create; post :create, :article => {}; end
  def do_show; get :show, :id => @article.id; end
  def do_new; get :new; end
  def do_update; put :update, :id => @article.id; end
  def do_edit; get :edit, :id => @article.id; end
  def do_destroy; delete :destroy, :id => @article.id; end
  
  authenticated_actions [:create, :new, :update, :edit, :destroy]
  public_actions [:index, :show]
  it_should_behave_like "a protected controller"
  
  describe "GET index" do
    before(:each) do
      mock_article
    end
    describe "with html" do
      before(:each) do
        page_items
      end
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
      before(:each) do
        feed_items
      end
      it "assigns articles" do
        do_index 'application/atom+xml'
        assigns[:articles].should == [@article]
      end
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
      login
    end
    describe "when successful" do
      before(:each) do
        @article.stub!(:save).and_return true
      end
      it "flashes success" do
        do_create
        flash[:notice].should_not be_blank
      end
      it "redirects to article permalink url" do
        do_create
        response.should redirect_to(article_permalink_url(@article))
      end
      it "assigns user to article" do
        @article.should_receive(:user=).with(@user)
        do_create
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
      login
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
      login
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
        flash[:notice].should_not be_blank
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
      login
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
      login
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
