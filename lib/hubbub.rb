module Hubbub
  begin
    Config = YAML.load_file("#{RAILS_ROOT}/config/hubbub.yml")
  rescue
    Config = {
      :title => "Hubbub",
      :tagline => "Pure Blogging Simplicity",
      :feed_items_length => 5,
      :page_items_length => 10
    }
  end
end