# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def config
    Hubbub::Config
  end
  
  def title page_title
    @title = page_title
    head = page_title.blank? ? "" : "#{page_title} - "
    content_for(:title) { "#{head}#{config[:title]}" }
  end
  
  def pretty_date date
    
  end
end
