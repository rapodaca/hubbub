# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'warp_drive/tasks'

WarpDrive.configure do |config|
  # Define your gem spec settings here:
  config.gem.version = "0.0.11"
  config.gem.name = 'hubbub'
  
  # Add your gem dependencies here:
  config.dependencies = {
    'warp_drive' => '>=0.1.8'
  }
end
    
