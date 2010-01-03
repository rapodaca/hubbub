require 'spec_helper'

describe User do
  before(:each) do
    @atts = {
      :openid_identifier => 'foo.bar.com'
    }
  end
  
  def do_new
    @user = User.new @atts
  end
  
  describe "with valid attributes" do
    it "is valid" do
      do_new
      @user.should be_valid
    end
    
    it "has no articles" do
      do_new
      @user.articles.should be_empty
    end
    
    describe "but without openid" do
      before(:each) do
        @atts[:openid_identifier] = nil
        do_new
      end
      it "is invalid" do
        @user.should_not be_valid
      end
    end
  end
end
