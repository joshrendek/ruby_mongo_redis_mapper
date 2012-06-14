require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"

require "./qdata"

missing_items = File.open("./dot_missing_items.csv").collect {|l| l.split(",")[0].strip }
# missing_items.shift # remove headers

missing_items.each_slice(8) do |batch|
    batch_search = []
    batch.each_with_index do |item, index|
        batch_search << " #{item} "
    end
    Resque.enqueue(ResqueSearcher, "", batch_search, true, 2)
end

p "Jobs enqueued"
