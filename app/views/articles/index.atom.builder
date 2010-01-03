atom_feed(
  :url         => articles_url(:format => 'atom'),
  :root_url    => root_url,
  :schema_date => '2008'
) do |feed|
  feed.title     Hubbub::Config[:title]
  feed.updated   @articles.empty? ? Time.now.utc : @articles.collect(&:updated_at).max
  feed.generator "Hubbub", "uri" => "http://github.com/rapodaca/hubbub"

  @articles.each do |article|
   feed.entry(article, :url => article_permalink_url(article), :published => article.created_at, :updated => article.updated_at) do |entry|
      entry.title   article.title
      entry.content article.body_html, :type => 'html'
    end
  end
end
