require 'spec_helper'

describe Tag do
  before(:each) do
    @atts = {
      :slug => 'novels'
    }
  end
  
  def mock_article
    @article = mock_model(Article)
  end
  
  def do_create
    @tag = Tag.new @atts
  end
  
  it "has no taggings" do
    do_create
    @tag.taggings.should be_empty
  end
  
  it "has no weight" do
    do_create
    @tag.save
    @tag.weight.should == 0
  end
  
  it "has no recent articles" do
    do_create
    @tag.save
    @tag.recent_articles.should == []
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@atts)
  end
  
  describe "#to_param" do
    it "returns slug" do
      do_create
      @tag.to_param.should == @tag.slug
    end
  end
  
  describe "with three article" do
    before(:each) do
      @first = Article.create!(:title => 'first', :body => 'body', :tag_slugs => 'foo', :created_at => 2.days.ago)
      @second = Article.create!(:title => 'second', :body => 'body', :tag_slugs => 'foo', :created_at => 5.days.ago)
      @third = Article.create!(:title => 'third', :body => 'body', :tag_slugs => 'foo', :created_at => Time.now)
      @tag = Tag.find_by_slug 'foo'
    end
    
    describe "#recent_articles" do
      it "returns them in the correct order" do
        @tag.recent_articles.should == [@third, @first, @second]
      end
      
      describe "on page 2" do
        it "returns nothing" do
          @tag.recent_articles(2).should == []
        end
      end
    end
  end
  
  describe "with three taggings" do
    before(:each) do
      do_create
      Tagging.stub!(:count).and_return 3
    end
    
    describe "#weight" do
      it "returns 3" do
        @tag.weight.should == 3
      end
    end
  end
  
  describe "without a slug" do
    it "is invalid" do
      @atts[:slug] = nil
      do_create
      @tag.should_not be_valid
    end
  end
end
