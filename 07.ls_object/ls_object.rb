# frozen_string_literal: true

require_relative 'entry'
require_relative 'display'
require 'optparse'

def main
  options = parse_options
  entry_names = options[:a] ? Dir.entries('.').sort : Dir.glob('*')
  entries = entry_names.map { |entry_name| Entry.new(entry_name) }
  sorted_entries = options[:r] ? entries.reverse : entries
  display = Display.new(sorted_entries)
  display.display_entries(long_format: options[:l])
end

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |all| options[:a] = all }
  opt.on('-r') { |reverse| options[:r] = reverse }
  opt.on('-l') { |long| options[:l] = long }
  opt.parse!(ARGV)
  options
end

main
