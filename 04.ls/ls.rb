#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def check_opt
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |all| options[:a] = all }
  opt.on('-r') { |reverse| options[:r] = reverse }
  opt.parse!(ARGV)
  options
end

def dirs_list
  opt = check_opt
  if opt[:a]
    Dir.entries('.').sort
  elsif opt[:r]
    Dir.glob('*').reverse
  else
    Dir.glob('*')
  end
end

def display_dirs
  dirs = dirs_list
  dirs.size
  max_length = dirs.max_by(&:length).length + 1
  terminal_cols = `tput cols`.to_i
  output_rows = (dirs.size.to_f / (terminal_cols / max_length).floor).ceil
  output_rows.times do |row|
    row.step(dirs.size - 1, output_rows) do |col|
      print dirs[col].ljust(max_length)
    end
    print "\n"
  end
end

display_dirs
