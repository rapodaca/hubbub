class Tag < ActiveRecord::Base
  validates_presence_of :slug
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :articles
  
  def weight
    Tagging.count :conditions => "tag_id = #{self.id}"
  end
  
  def to_param
    self.slug
  end
  
  def page_articles page=nil
    Article.paginate :page => page,
                     :joins => :taggings,
                     :order => 'articles.created_at DESC',
                     :conditions => ['taggings.tag_id=?', self.id],
                     :per_page      => Hubbub::Config[:items_per_page] || 10
  end
  
  def feed_articles
    Article.find :all,
                 :joins => :taggings,
                 :order => 'articles.created_at DESC',
                 :conditions => ['taggings.tag_id=?', self.id],
                 :limit      => Hubbub::Config[:items_per_feed] || 5
  end
end
