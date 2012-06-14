require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"

require "./qdata"

missing_items = File.open("missing_items.csv").collect {|l| l }
missing_items.shift # remove headers

missing_items_by_agency = {}
p "Seperating by agency"
missing_items.each do |line|
    r = line.gsub('"', '').split(",")
    # p missing_items_by_agency
    if missing_items_by_agency[r[2]].nil?
        missing_items_by_agency[r[2]] = [line.gsub('"', '').split(",")[0]]
    else
        missing_items_by_agency[r[2]] << line.gsub('"', '').split(",")[0]
    end
end
p "Done"

missing_items_by_agency.each do |k,v|
    next if k == "DOT"
    p "Parsing #{k}"
    missing_items_by_agency[k].each_slice(8) do |batch|
        batch_search = []
        batch.each_with_index do |item, index|
            batch_search << " #{item} "
        end
        Resque.enqueue(FileSearcher, "#{k}_WorkOrderComments.csv", batch_search, true, 2)
    end

    p "Jobs enqueued"
end

