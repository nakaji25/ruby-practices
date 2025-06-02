#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'find'

def check_opt
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |lines| options[:l] = lines }
  opt.on('-w') { |words| options[:w] = words }
  opt.on('-c') { |byte| options[:c] = byte }
  opt.parse!(ARGV)
  options = { c: true, l: true, w: true } if options.empty?
  options
end

def build_counts(str)
  {
    lines: str.count("\n"),
    words: str.split(/\s+/).size,
    characters: str.encode('UTF-8').bytesize
  }
end

def display_totals(counts, opt)
  print total_count(counts, :lines).to_s.rjust(8) if opt[:l]
  print total_count(counts, :words).to_s.rjust(8) if opt[:w]
  print total_count(counts, :characters).to_s.rjust(8) if opt[:c]
  puts ' total'
end

def total_count(counts, key)
  counts.sum { |count| count[key] }
end

def display_counts(counts, opt)
  counts.each_with_index do |count, index|
    print count[:lines].to_s.rjust(8) if opt[:l]
    print count[:words].to_s.rjust(8) if opt[:w]
    print count[:characters].to_s.rjust(8) if opt[:c]
    puts " #{ARGV[index] unless ARGV.empty?}"
  end
  return if ARGV.empty?

  display_totals(counts, opt)
end

def check_inputs
  opt = check_opt
  counts = if ARGV.empty?
             [build_counts($stdin.readlines.join)]
           else
             ARGV.map do |file|
               str = File.open(file).read
               build_counts(str)
             end
           end
  display_counts(counts, opt)
end

check_inputs
