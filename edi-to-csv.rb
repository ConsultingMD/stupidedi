#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'csv'

Bundler.require

require "stupidedi"

$debug = false

config = Stupidedi::Config.hipaa
machine = Stupidedi::Builder::StateMachine.build(config)
input = File.open('walmart-big.txt', :encoding => 'ISO-8859-1')
parser, result = machine.read(Stupidedi::Reader.build(input))

def print_all_elements_in(node)
  element_position = 1
  begin
    while node.elementn(element_position)
      if $debug
        puts node.elementn(element_position).fetch.value rescue nil
      end
      element_position += 1
    end
  rescue ArgumentError
    false
  end
end

def csv_all_elements_in(node)
  element_position = 1
  row = []
  begin
    while node.elementn(element_position)
      row << node.elementn(element_position).fetch.value rescue nil
      element_position += 1
    end
  rescue ArgumentError
    false
  end
  row
end

def print_header
end

#this gets you to the GS node.  Basically it creates a tree that it calls StateMachine
node = parser.first.fetch.find(:GS).fetch
first_row = true

loop do
  break if node.segmentn.fetch.id == :INS
  puts node.segmentn.fetch.id if $debug
  print_all_elements_in(node)
  node = node.next.fetch
end

row = []

CSV.open('/tmp/834.csv', 'wb', :col_sep => ",") do |csv|
  until node.last?
    if node.segmentn.fetch.id == :INS
      puts ("-" * 10) if $debug
      csv << row unless row.empty?
      row = []
    end
    puts node.segmentn.fetch.id if $debug
    row = row + csv_all_elements_in(node)
    node = node.next.fetch
  end
  csv << row unless row.empty?
end


#BUG, we are missing the last :REF on the last :INS
