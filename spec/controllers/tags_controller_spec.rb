require 'spec_helper'

describe TagsController do
  def mock_tag
    @tag = mock_model(Tag)
  end
  def find_tags
    Tag.stub!(:find).and_return [@tag]
  end
  def find_tag
    Tag.stub!(:find).and_return @tag
  end
  def tag_has_one_article
    @article = mock_model(Article)
    @tag.stub!(:recent_articles).and_return [@article]
  end
  
  def do_index; get :index; end
  def do_show; get :show, :id => @tag.id; end
  def do_update; put :update, :id => @tag.id; end
  def do_edit; get :edit, :id => @tag.id; end
  def do_destroy; delete :destroy, :id => @tag.id; end
  
  describe "GET index" do
    before(:each) do
      mock_tag
      find_tags
    end
    it "assigns tags" do
      do_index
      assigns[:tags].should == [@tag]
    end
    describe "as atom" do
      it "returns atom content" do
        get :index, :format => 'atom'
        response.content_type.should == 'application/atom+xml'
      end
    end
  end
  
  describe "GET show" do
    before(:each) do
      mock_tag
      find_tag
      tag_has_one_article
    end
    it "assigns tag" do
      do_show
      assigns[:tag].should == @tag
    end
    it "assigns articles" do
      do_show
      assigns[:articles].should == [@article]
    end
  end
  
  describe "PUT update" do
    before(:each) do
      mock_tag
      find_tag
    end
    it "updates tag attributes" do
      @tag.should_receive(:update_attributes).and_return true
      do_update
    end
    describe "when successful" do
      before(:each) do
        @tag.stub!(:update_attributes).and_return(true)
      end
      it "flashes success" do
        do_update
        flash[:notice].should_not be_nil
      end
      it "redirects to tag url" do
        do_update
        response.should redirect_to(tag_url(@tag))
      end
    end
    describe "when unsuccessful" do
      before(:each) do
        @tag.stub!(:update_attributes).and_return(false)
      end
      it "renders new" do
        do_update
        response.should render_template(:edit)
      end
    end
  end
  
  describe "GET edit" do
    before(:each) do
      mock_tag
      find_tag
    end
    
    it "assigns tag" do
      do_edit
      assigns[:tag].should == @tag
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      mock_tag
      find_tag
      @tag.stub!(:destroy)
    end
    
    it "destroys tag" do
      @tag.should_receive(:destroy)
      do_destroy
    end
    
    it "flashes success" do
      do_destroy
      flash[:notice].should_not be_blank
    end
    
    it "redirects to tags url" do
      do_destroy
      response.should redirect_to(tags_url)
    end
  end
end
