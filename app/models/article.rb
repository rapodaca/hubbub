class Article < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :body
  validate :valid_tags?
  
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
  
  def self.feed_items
    self.find :all,
              :limit => Hubbub::Config[:items_per_feed] || 5,
              :order => 'created_at DESC'
  end
  
  def self.page_items page
    self.paginate :order => 'created_at DESC',
                  :per_page => Hubbub::Config[:items_per_page] || 10,
                  :page => page
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
  
  private
  
  def valid_tags?
    taggings.each do |tagging|
      unless tagging.tag.valid?
        errors.add(:tag_slugs, "contains an invalid tag '#{tagging.tag.slug}'")
      end
    end
  end
end
