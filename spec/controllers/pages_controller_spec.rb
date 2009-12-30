require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/shared/protected_controller_spec')

describe PagesController do
  authenticated_actions [:create, :new, :update, :edit, :destroy]
  public_actions [:index, :show]
  it_should_behave_like "a protected controller"

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
