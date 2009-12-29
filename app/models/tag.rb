class Tag < ActiveRecord::Base
  validates_presence_of :slug
  
  has_many :taggings
  has_many :tags, :through => :articles
  
  def weight
    Tagging.count :conditions => "tag_id = #{self.id}"
  end
  
  def to_param
    self.slug
  end
  
  def recent_articles page=1
    options = {
      :page => page,
      :joins => :taggings,
      :order      => 'articles.created_at DESC',
      :conditions => ['taggings.tag_id=?', self.id],
      :per_page      => Hubbub::Config[:articles_per_page]
    }
    
    Article.paginate options
  end
end
