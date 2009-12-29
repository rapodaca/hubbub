class Page < ActiveRecord::Base
  validates_presence_of :title, :body
  validates_uniqueness_of :title_slug
  
  marks_up :body
  slugifies :title
  
  def to_param
    title_slug
  end
end
