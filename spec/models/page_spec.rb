require 'spec_helper'

describe Page do
  before(:each) do
    @atts = {
      :title => "Lorum Ipsum",
      :body => "Lorem ipsum dolor sit ame..."
    }
  end
  
  def do_new
    @page = Page.new @atts
  end
  
  describe "with valid attributes" do
    before(:each) do
      do_new
    end
    it "is valid" do
      @page.should be_valid
    end
    describe "#to_param" do
      it "returns title_slug" do
        @page.valid?
        @page.to_param.should == 'lorum-ipsum'
      end
    end
    
    describe "#save" do
      before(:each) do
        @page.save
      end
      it "generates body_html" do
        @page.body_html.should == "<p>Lorem ipsum dolor sit ame...</p>\n"
      end
      it "generates slug" do
        @page.title_slug.should == "lorum-ipsum"
      end
    end
    
    describe "and a duplicate title" do
      before(:each) do
        @page.save
        @duplicate = Page.new :title => 'Lorum Ipsum', :body => 'foo bar'
      end
      
      it "is invalid" do
        @duplicate.should_not be_valid
      end
    end
    
    describe "when title_slug is specified" do
      before(:each) do
        @page.title_slug = 'kowabunga'
      end
      
      describe "#save" do
        it "does not change title_slug" do
          @page.save
          @page.title_slug.should == 'kowabunga'
        end
      end
    end
  end
end
