#!/usr/bin/env ruby
require 'date'
require 'optparse'

opt = OptionParser.new
today = Date.today
values = [today.year,today.month]
opt.on('-y int') {|v| values[0] = v.to_i }
opt.on('-m int') {|v| values[1] = v.to_i }
opt.parse!(ARGV)

week = ["日","月","火","水","木","金","土"]
start_day = Date.new(values[0],values[1],1)
end_day = Date.new(values[0],values[1],-1).day.to_i

puts "      " + values[1].to_s + "月" + values[0].to_s
week.each do |w|
  print w + " "
end
print "\n"
(1..start_day.cwday).each do |space|
  print "   "
end
(0..end_day-1).each do |d| 
  calender = start_day + d
  calender_day = calender.day.to_s + " " 
  calender_day = " " + calender_day if (calender.day < 10) 
  
  if (calender.cwday == 6) || (calender.day == end_day)
    puts calender_day 
  else
    print calender_day
  end
end