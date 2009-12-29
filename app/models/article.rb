class Article < ActiveRecord::Base
  before_validation :generate_slug
  before_save :markdown_body
  validates_presence_of :title
  validates_presence_of :body
  
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
      :per_page => Hubbub::Config[:articles_per_page]
    }.merge(options)
    
    self.paginate options
  end
  
  def self.find_by_permalink options={}
    begin
      article = self.find_all_by_slug(options[:slug]).detect do |article|
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
  
  def markdown_body
    self.body_html = RDiscount.new(body).to_html
  end
  
  # See: http://stackoverflow.com/questions/1302022/best-way-to-generate-slugs-human-readable-ids-in-rails
  def generate_slug
    return if title.blank?
    #strip the string
    slug = title.strip.downcase
    
    slug = title.strip.downcase

    #blow away apostrophes
    slug.gsub! /['`]/,""

    # @ --> at, and & --> and
    slug.gsub! /\s*@\s*/, " at "
    slug.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with dash
    slug.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'  

    #convert double dash to single
    slug.gsub! /_+/,"-"

    #strip off leading/trailing dashes
    slug.gsub! /\A[-\.]+|[-\.]+\z/,""
    
    self.slug = slug
  end
end
