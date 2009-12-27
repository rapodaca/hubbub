class Article < ActiveRecord::Base
  before_validation :generate_slug
  after_save :markdown_body
  validates_presence_of :title
  validates_presence_of :body
  
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
