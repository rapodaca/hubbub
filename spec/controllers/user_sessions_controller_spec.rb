require 'spec_helper'

describe UserSessionsController do
  def mock_user_session
    @user_session = mock_model(UserSession)
  end
  
  def do_new; get :new; end
  def do_create; post :create end
  def do_destroy; delete :destroy; end
  
  def new_user_session
    UserSession.stub!(:new).and_return @user_session
  end
  
  def login
    UserSession.stub!(:find).and_return @user_session
  end
  
  def logout
    UserSession.stub!(:find).and_return nil
  end
  
  describe "POST create" do
    before(:each) do
      mock_user_session
      new_user_session
    end
    
    describe "when successful" do
      before(:each) do
        @user_session.stub!(:save).and_yield true
      end
      it "redirects to root url" do
        do_create
        response.should redirect_to(root_url)
      end
    end
    
    describe "when unsuccessful" do
      before(:each) do
        @user_session.stub!(:save).and_yield false
      end
      it "renders new" do
        do_create
        response.should render_template(:new)
      end
    end
  end
  
  describe "GET new" do
    before(:each) do
      mock_user_session
      new_user_session
    end
    
    it "assings user_session" do
      do_new
      assigns[:user_session].should == @user_session
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      mock_user_session
    end
    
    describe "when logged in" do
      before(:each) do
        login
        @user_session.stub!(:destroy).and_return true
      end
      it "redirects to root url" do
        do_destroy
        response.should redirect_to(root_url)
      end
      it "flashes success" do
        do_destroy
        flash[:success].should_not be_blank
      end
    end
    describe "when logged out" do
      before(:each) do
        logout
      end
      it "flashes warning" do
        do_destroy
        flash[:warning].should_not be_blank
      end
    end
  end
end