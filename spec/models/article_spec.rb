require 'spec_helper'

describe Article do
  before(:each) do
    @atts = {
      :title => "A Tale of Two Cities",
      :body => "It was the best of times, it was the worst of times."
    }
  end
  
  def do_create
    @article = Article.new @atts
  end

  it "should create a new instance given valid attributes" do
    do_create
    @article.valid?.should == true
  end
  
  it "has no html body" do
    do_create
    @article.body_html.should be_blank
  end
  
  it "has no taggings" do
    do_create
    @article.taggings.should be_empty
  end
  
  it "has no tags" do
    do_create
    @article.tags.should be_empty
  end
  
  describe "#find_recent" do
    before(:each) do
      @first = Article.create!(:title => 'First', :body => 'First article.', :created_at => 1.day.ago)
      @second = Article.create!(:title => 'Second', :body => 'Second article.', :created_at => 2.day.ago)
      @third = Article.create!(:title => 'Third', :body => 'Third article.', :created_at => 3.day.ago)
    end
    describe "limit two per page" do
      before(:each) do
        Hubbub::Config.stub!(:[]).with(:articles_per_page).and_return(2)
      end
      it "returns last article" do
        articles = Article.find_recent :page => 1
        articles.should == [@first, @second]
      end
    end
  end
  
  describe "#find_by_permalink" do
    before(:each) do
      @article = Article.create!(:title => 'First',
      :body => 'First article.')
    end
    
    describe "with valid date and slug params" do
      before(:each) do
        @atts = {
          :year => @article.created_at.year,
          :month => @article.created_at.month,
          :day => @article.created_at.day,
          :slug => 'first'
        }
      end
      it "returns article" do
        article = Article.find_by_permalink @atts
        article.should == @article
      end
      describe "but with invalid date" do
        before(:each) do
          @atts[:day] = @atts[:day] + 1
        end
        it "raises" do
          lambda{Article.find_by_permalink}.should raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
  
  describe "#valid?" do
    it "generates slug" do
      do_create
      @article.valid?
      @article.slug.should == 'a-tale-of-two-cities'
    end
  end
  
  describe "tag_slugs virtual attribute" do
    describe "with three valid tags" do
      before(:each) do
        @atts[:tag_slugs] = "one two three"
        do_create
      end
      it "is valid" do
        @article.should be_valid
      end
      describe "#tags" do
        it "returns three tags" do
          @article.taggings.inject([]) { |taggings, tagging| taggings << tagging.tag.slug }.should == ['one', 'two', 'three']
        end
      end
    end
  end
  
  describe "#save" do
    it "runs markdown" do
      do_create
      @article.save
      @article.body_html.should == "<p>It was the best of times, it was the worst of times.</p>\n"
    end
  end
  
  describe "without title" do
    it "is invalid" do
      @atts[:title] = nil
      do_create
      @article.valid?.should == false
    end
  end
  
  describe "without a body" do
    it "is invalid" do
      @atts[:body] = nil
      do_create
      @article.valid?.should == false
    end
  end
end
