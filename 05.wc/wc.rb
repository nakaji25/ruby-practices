#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  opt = parse_options
  counts =
    if ARGV.empty?
      [build_counts($stdin.readlines.join)]
    else
      ARGV.map do |file|
        str = File.read(file)
        build_counts(str, file)
      end
    end
  display_counts(counts, opt)
end

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |lines| options[:l] = lines }
  opt.on('-w') { |words| options[:w] = words }
  opt.on('-c') { |byte| options[:c] = byte }
  opt.parse!(ARGV)

  return { c: true, l: true, w: true } if options.empty?

  options
end

def build_counts(str, path = nil)
  {
    lines: str.count("\n"),
    words: str.split(/\s+/).size,
    characters: str.encode('UTF-8').bytesize,
    path: path
  }
end

def display_counts(counts, opt)
  counts.each do |count|
    print generate_padding(count[:lines]) if opt[:l]
    print generate_padding(count[:words]) if opt[:w]
    print generate_padding(count[:characters]) if opt[:c]
    puts count[:path].nil? ? '' : " #{count[:path]}"
  end
  display_totals(counts, opt) if ARGV.size >= 2
end

def generate_padding(str)
  str.to_s.rjust(8)
end

def display_totals(counts, opt)
  print generate_padding(sum_count(counts, :lines)) if opt[:l]
  print generate_padding(sum_count(counts, :words)) if opt[:w]
  print generate_padding(sum_count(counts, :characters)) if opt[:c]
  puts ' total'
end

def sum_count(counts, key)
  counts.sum { |count| count[key] }
end

main
