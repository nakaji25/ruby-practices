# frozen_string_literal: true

require_relative 'directory'
require_relative 'display'
require 'optparse'

def main
  opt = parse_opt
  dir_names = if opt[:a]
                Dir.entries('.').sort
              else
                Dir.glob('*')
              end
  dirs = dir_names.map { |dir_name| Directory.new(dir_name) }
  dirs.reverse! if opt[:r]
  display = Display.new(dirs)
  if opt[:l]
    display.display_long
  else
    display.display_dirs
  end
end

def parse_opt
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |all| options[:a] = all }
  opt.on('-r') { |reverse| options[:r] = reverse }
  opt.on('-l') { |long| options[:l] = long }
  opt.parse!(ARGV)
  options
end

main
