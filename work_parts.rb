require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"

require "./qdata"

missing_parts = File.open("acs_no_items_acts.csv").collect {|l| l.split(",")[0].gsub('"', '') }

k = "ACS"
missing_parts.each_slice(8) do |batch|
    batch_search = []
    batch.each_with_index do |item, index|
        batch_search << item
    end
    Resque.enqueue(FileSearcher, "#{k}_WorkOrderParts.csv", batch_search, true, 2)
end

p "Jobs enqueued"

