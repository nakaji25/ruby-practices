#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  counts =
    if ARGV.empty?
      [build_counts($stdin.readlines.join)]
    else
      ARGV.map do |file|
        str = File.read(file)
        build_counts(str, file)
      end
    end
  counts.each { |count| display_count(count, options) }
  total_counts(counts, options) if ARGV.size >= 2
end

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |lines| options[:l] = lines }
  opt.on('-w') { |words| options[:w] = words }
  opt.on('-c') { |byte| options[:c] = byte }
  opt.parse!(ARGV)

  options.empty? ? { c: true, l: true, w: true } : options
end

def build_counts(str, path = nil)
  {
    lines: str.count("\n"),
    words: str.split(/\s+/).size,
    chars: str.encode('UTF-8').bytesize,
    path: path
  }
end

def display_count(count, options)
  print format_number(count[:lines]) if options[:l]
  print format_number(count[:words]) if options[:w]
  print format_number(count[:chars]) if options[:c]
  puts " #{count[:path]}".rstrip
end

def format_number(number)
  number.to_s.rjust(8)
end

def total_counts(counts, options)
  sum = ->(key) { counts.sum { |count| count[key] } }
  total = {
    lines: sum.call(:lines),
    words: sum.call(:words),
    chars: sum.call(:chars),
    path: 'total'
  }
  display_count(total, options)
end

def sum_count(counts, key)
  counts.sum { |count| count[key] }
end

main
