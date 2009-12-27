class Tagging < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag
  
  validates_presence_of :article
  validates_presence_of :tag
end
