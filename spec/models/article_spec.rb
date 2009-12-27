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
  
  describe "#valid?" do
    it "generates slug" do
      do_create
      @article.valid?
      @article.slug.should == 'a-tale-of-two-cities'
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
