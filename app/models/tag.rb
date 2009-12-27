class Tag < ActiveRecord::Base
  validates_presence_of :slug
  
  has_many :taggings
  has_many :tags, :through => :articles
end
