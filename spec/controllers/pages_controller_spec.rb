require 'spec_helper'

describe PagesController do
  describe "POST create" do
    before(:each) do
      @page = mock_model(Page, :save => true)
      Page.stub!(:new).and_return @page
    end
    describe "when successfu" do
      it "flashes success" do
        post :create, :page => {}
        flash[:success].should_not be_blank
      end
    end
  end
  describe "GET index" do
    it "sorts pages by time created" do
      Page.should_receive(:find).with(:all, :order => 'created_at DESC')
      get :index
    end
  end
  describe "GET show" do
    it "finds by title_slug" do
      Page.should_receive(:find_by_title_slug!)
      get :show, :id => 1
    end
  end
end
