require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"
require "mongoid"
require './dot_mongoid'

# class Artist
  # include Mongoid::Document
  # field :name, type: String
  # embeds_many :instruments
# end
# 


File.open("DOT_WorkOrderDetail.csv", "r").each do |l|
    sl = l.split('","')
    WO.create({:wo_number => sl[2], :line => l})
    p "Processed: #{sl[2]}"
end

WO.create_indexes()
