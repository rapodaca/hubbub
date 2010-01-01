module Hubbub
  begin
    Config = YAML.load_file("#{RAILS_ROOT}/config/hubbub.yml")
  rescue
    Config = {
      :title => "Hubbub",
      :tagline => "Pure Blogging Simplicity",
      :articles_per_page => 10
    }
  end
end