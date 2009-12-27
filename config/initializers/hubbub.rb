module Hubbub
  begin
    Config = YAML.load_file("#{RAILS_ROOT}/config/hubbub.yml")
  rescue
    Config = {  }
  end
end