require 'spec_helper'

describe Tagging do
  before(:each) do
    @atts = {
      :article => mock_model(Article),
      :tag => mock_model(Tag)
    }
  end
  
  def do_create
    @tagging = Tagging.new @atts
  end

  it "should create a new instance given valid attributes" do
    Tagging.create!(@atts)
  end
  
  describe "without an article" do
    it "is invalid" do
      @atts[:article] = nil
      do_create
      @tagging.should_not be_valid
    end
  end
  
  describe "without a tag" do
    it "is invalid" do
      @atts[:tag] = nil
      do_create
      @tagging.should_not be_valid
    end
  end
end
