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
  
  describe "GET index" do
    before(:each) do
      mock_tag
      find_tags
    end
    it "assigns tags" do
      do_index
      assigns[:tags].should == [@tag]
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
end
