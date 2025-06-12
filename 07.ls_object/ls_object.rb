# frozen_string_literal: true

require_relative 'entry'
require_relative 'display'
require 'optparse'

def main
  options = parse_options
  entry_names = if options[:a]
                  Dir.entries('.').sort
                else
                  Dir.glob('*')
                end
  entries = entry_names.map { |entry_name| Entry.new(entry_name) }
  display = options[:r] ? Display.new(entries.reverse) : Display.new(entries)
  if options[:l]
    display.display_long
  else
    display.display_entries
  end
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
