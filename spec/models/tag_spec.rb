require 'spec_helper'

describe Tag do
  before(:each) do
    @atts = {
      :slug => 'novels'
    }
  end
  
  def do_create
    @tag = Tag.new @atts
  end
  
  it "has no taggings" do
    do_create
    @tag.taggings.should be_empty
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@atts)
  end
  
  describe "without a slug" do
    it "is invalid" do
      @atts[:slug] = nil
      do_create
      @tag.should_not be_valid
    end
  end
end
