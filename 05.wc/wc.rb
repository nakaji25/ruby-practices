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
  counts.map { |count| display_count(count, options) }
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
    characters: str.encode('UTF-8').bytesize,
    path: path
  }
end

def display_count(count, options)
  print_padding(count[:lines]) if options[:l]
  print_padding(count[:words]) if options[:w]
  print_padding(count[:characters]) if options[:c]
  puts count[:path].nil? ? '' : " #{count[:path]}"
end

def print_padding(str)
  print str.to_s.rjust(8)
end

def total_counts(counts, options)
  total =
    {
      lines: sum_count(counts, :lines),
      words: sum_count(counts, :words),
      characters: sum_count(counts, :characters),
      path: 'total'
    }
  display_count(total, options)
end

def sum_count(counts, key)
  counts.sum { |count| count[key] }
end

main
