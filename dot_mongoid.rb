require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"
require "mongoid"


Mongoid.configure do |config|
  name = "fleet_dot"
  host = "localhost"
  port = 27017
  config.database = Mongo::Connection.new.db(name)
end

class WO
    include Mongoid::Document
    field :wo_number, type: String
    field :line, type: String
    index :wo_number
end

