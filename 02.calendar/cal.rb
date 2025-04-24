#!/usr/bin/env ruby
require 'date'
require 'optparse'

INDENT_SPACES = ' ' * 5
START_INDENTS = ' ' * 3

opt = OptionParser.new
today = Date.today
year = today.year
month = today.month

opt.on('-y int') { |v| year = v.to_i }
opt.on('-m int') { |v| month = v.to_i }
opt.parse!(ARGV)

weeks = %w[日 月 火 水 木 金 土]
start_day = Date.new(year, month, 1)
end_day = Date.new(year, month, -1)

puts INDENT_SPACES + "#{month.to_s.rjust(2)}月 #{year.to_s.rjust(4)}"
puts weeks.join(' ')
(1..start_day.cwday).each do
  print START_INDENTS
end

(start_day..end_day).each do |date|
  print ' ' unless (date.cwday == weeks.length) || (date.day == start_day.day)
  print date.day.to_s.rjust(2)
  print "\n" if (date.cwday == weeks.length - 1) || (date.day == end_day.day)
end
