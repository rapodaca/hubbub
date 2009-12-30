require 'spec_helper'

describe PagesController do
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
