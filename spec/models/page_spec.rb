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
    
    describe "#valid?" do
      before(:each) do
        @page.valid?
      end
      # it "generates slug" do
      #   @page.slug.should == "lorum-ipsum"
      # end
    end
  end
end
