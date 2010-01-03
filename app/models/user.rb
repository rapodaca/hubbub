class User < ActiveRecord::Base
  validates_presence_of :openid_identifier
  has_many :articles
  
  acts_as_authentic
end
