# See: http://heypanda.com/posts/63-Extending-Your-Models-Using-Custom-Plugins-Or-A-Brief-Introduction-to-Metaprogramming
module Postable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def marks_up(attribute)
      before_validation "convert_#{attribute}_to_markdown".to_sym
      class_eval <<-EOC
        def convert_#{attribute}_to_markdown
          unless self.#{attribute}.blank?
            self.#{attribute}_html = RDiscount.new(#{attribute}).to_html
          end
        end
        private :convert_#{attribute}_to_markdown
      EOC
    end
    
    def slugifies(attribute)
      before_validation "convert_#{attribute}_to_slug".to_sym
      class_eval <<-EOC
        def convert_#{attribute}_to_slug
          if self.#{attribute}_slug.blank?
            self.#{attribute}_slug = generate_slug(#{attribute})
          end
        end
        private :convert_#{attribute}_to_slug
      EOC
    end
  end
  
  private
  
  # See: http://stackoverflow.com/questions/1302022/best-way-to-generate-slugs-human-readable-ids-in-rails
  def generate_slug(text)
    return if text.blank?
    #strip the string
    slug = text.strip.downcase

    #blow away apostrophes
    slug.gsub! /['`]/,""

    # @ --> at, and & --> and
    slug.gsub! /\s*@\s*/, " at "
    slug.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore with dash
    slug.gsub! /\s*[^A-Za-z0-9\-]\s*/, '-'  

    #convert double dash to single
    slug.gsub! /_+/,"-"

    #strip off leading/trailing dashes
    slug.gsub! /\A[-\.]+|[-\.]+\z/,""
    
    slug
  end
end
