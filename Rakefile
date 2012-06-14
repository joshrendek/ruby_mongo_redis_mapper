require "rubygems"
require "bundler/setup"
require "rake"
require "resque/tasks"  
require "yaml"
require "./qdata"

CONFIG = YAML::load(File.open("config.yml"))

Resque.redis = CONFIG["master"]["host"]

namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup do
  end
end

task :default do

end
