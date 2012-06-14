require "rubygems"
require "bundler/setup"
require "resque"
require "logger"
require "date"
require "mongoid"
require './dot_mongoid'


class FileSearcher
    @queue = :search
    def self.perform(filename, search, split_search = false, col = nil)
        logger = Logger.new("qdata.log")
        logger.info "Opening #{filename} to search for #{search}"
        file_contents = File.open(filename).collect {|l| l }
        logger.info "File size: #{file_contents.count} lines"
        out = []
        file_contents.each do |l|
            search.each do |s|
                if split_search
                    split_line = l.split(",")
                    out << l if split_line[col].include?(s)
                else
                    out << l if l.include?(s)
                end
            end
        end
        File.open("qdata-" + `hostname`.strip + ".out", "a+") do |f|
            out.each do |o|
                f.puts o
            end
        end
    end
end

class ResqueSearcher 
    @queue = :search
    def self.perform(filename, search, split_search = false, col = nil)
        # file_contents = File.open(filename).collect {|l| l }
        out = []
        search.each do |s|
            wo = WO.where(:wo_number => s)
            wo.each do |w|
                unless w.blank?
                    out << w.line
                end
            end
        end
        File.open("qdata-" + `hostname`.strip + ".out", "a+") do |f|
            out.each do |o|
                f.puts o
            end
        end
    end
end

# 100.times.each do
# Resque.enqueue(FileSearcher, "test.data", "horse")
# end
