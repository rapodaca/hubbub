require 'spec_helper'

describe TagsController do
  def mock_tag
    @tag = mock_model(Tag)
  end
  def find_tags
    mock_tag
    Tag.stub!(:find).and_return [@tag]
  end
  def find_tag
    mock_tag
    Tag.stub!(:find).and_return @tag
  end
  def tag_has_one_article
    @article = mock_model(Article)
    @tag.stub!(:recent_articles).and_return [@article]
  end
  
  describe "GET index" do
    it "assigns tags" do
      find_tags
      get :index
      assigns[:tags].should == [@tag]
    end
  end
  
  describe "GET show" do
    before(:each) do
      find_tag
      tag_has_one_article
    end
    it "assigns tag" do
      get :show, :id => @tag.id
      assigns[:tag].should == @tag
    end
    it "assigns articles" do
      get :show, :id => @tag.id
      assigns[:articles].should == [@article]
    end
    describe "as atom" do
      it "returns atom content" do
        get :show, :id => @tag.id, :format => 'atom'
        response.content_type.should == 'application/atom+xml'
      end
    end
  end
end
