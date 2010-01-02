class Article < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :body
  
  marks_up :body
  slugifies :title
  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  def tag_slugs=(slugs)
    slugs.split.each do |slug|
      tag = Tag.find_or_initialize_by_slug slug
      next if self.tags.member? tag
      self.taggings.build :tag => tag, :article => self
    end
  end
  
  def tag_slugs
    array = self.taggings.inject([]) do |slugs, tagging|
      slugs << tagging.tag.slug
    end
    array.join ' '
  end
  
  def self.find_recent options={}
    options = {
      :order => 'created_at DESC',
      :per_page => options.delete(:per_page) || Hubbub::Config[:articles_per_page],
      :page => options.delete(:page) || 1
    }.merge(options)
    
    self.paginate options
  end
  
  def self.find_by_permalink options={}
    begin
      article = self.find_all_by_title_slug(options[:slug]).detect do |article|
        time = article.created_at
        time.year == options[:year].to_i &&
        time.month == options[:month].to_i &&
        time.day == options[:day].to_i
      end
    rescue
      article = nil
    end

    article || raise(ActiveRecord::RecordNotFound)
  end
end
