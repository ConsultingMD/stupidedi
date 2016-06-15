#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'csv'

Bundler.require
$debug = false
input = File.open('walmart-big.txt', :encoding => 'ISO-8859-1')
ins_data = {}
csv = CSV.open('/tmp/834.csv', 'wb', :col_sep => ",")

$row_counter = 0


OUTPUT_GUIDE = [
                { :INS => 17 }, # get an INS segment with 17 elements
                { :REF => [4, 2] }, # get 4 REF segments, each with 2 elements
                { :DTP => [3, 3] },
                { :NM1 => 9 },
                { :PER => 8 },
                { :N3 => 1 },
                { :N4 => 3 },
                { :DMG => 3 },
                { :HLH => 3 },
                { :HD => 5 },
                { :AMT => 2 }
               ]

def dump_header_row(ins_data, csv)
  row = []
  OUTPUT_GUIDE.each do |guide|
    if guide.values.first.class == Fixnum
      row = row + guide.values.first.times.map {|i| "#{guide.keys.first.to_s}_#{i}"}
    else
      # Array
      guide.values.first.first.times do |idx|
        prefix = "#{guide.keys.first.to_s}_#{idx}"
        row = row + guide.values.first[1].times.map {|i| "#{prefix}_#{i}" }
      end
    end
  end
  csv << row
end

def output_to_csv(ins_data, csv)
  row = []
  OUTPUT_GUIDE.each do |guide|
    if guide.values.first.class == Fixnum
      if ins_data.has_key?(guide.keys.first.to_s)
        row = row + ins_data[guide.keys.first.to_s][0]
        unless ins_data[guide.keys.first.to_s][0].size == guide.values.first
          short_by = guide.values.first - ins_data[guide.keys.first.to_s][0].size
          row = row + short_by.times.map { '' }
        end
      else
        row = row + guide.values.first.times.map { '' }
      end
    else
      # Array
      guide.values.first.first.times do |idx|
        unless ins_data[guide.keys.first.to_s][idx].nil?
          row = row + ins_data[guide.keys.first.to_s][idx]
        else
          row = row + guide.values.first[1].times.map { '' }
        end
      end
    end
  end

  $row_counter = $row_counter + 1
  print '.' if $row_counter % 1000 == 0
  csv << row
end

first_row = true
input.each_line do |line|
  if segment = line.match(/(^[A-Z0-9]+)\*(.*?)$/)
    segment_type = segment[1]
    segment_data = segment[2].split(/\*/)
    if segment_type == 'INS'
      if first_row and !ins_data.has_key?('ISA')
        dump_header_row(ins_data, csv)
        first_row = false
      end
      output_to_csv(ins_data, csv) unless ins_data.has_key?('ISA')
      ins_data = {}
    end
    ins_data[segment_type] = ins_data[segment_type].nil? ? [ segment_data ] : ins_data[segment_type] << segment_data
  end
end
output_to_csv(ins_data, csv)

csv.close
exit

