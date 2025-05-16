#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def check_opt
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |all| options[:a] = all }
  opt.on('-r') { |reverse| options[:r] = reverse }
  opt.on('-l') { |long| options[:l] = long }
  opt.parse!(ARGV)
  options
end

def dirs_list
  opt = check_opt
  dirs = if opt[:a]
           Dir.entries('.').sort
         else
           Dir.glob('*')
         end
  dirs.reverse! if opt[:r]
  if opt[:l]
    display_long(dirs)
  else
    display_dirs(dirs)
  end
end

def long_format(dirs)
  file_type = { fifo: 'p', characterSpecial: 'c', directory: 'd', blockSpecial: 'b', file: '-', link: 'l', socket: 's' }
  dirs_blocks = 0
  long_dirs = Hash.new { |h, k| h[k] = [] }
  dirs.each do |dir|
    fs = File::Stat.new(dir)
    dirs_blocks += fs.blocks
    long_dirs[:file_type] << file_type[File.ftype(dir).to_sym]
    long_dirs[:permission] << dir_permission(fs)
    long_dirs[:nlink] << fs.nlink.to_s
    long_dirs[:owner_name] << Etc.getpwuid(fs.uid).name
    long_dirs[:grop_name] << Etc.getgrgid(fs.gid).name
    long_dirs[:dir_size] << fs.size.to_s
    long_dirs[:accses_time] << fs.atime.strftime('%_m %e %H:%M ')
  end
  long_dirs[:total_block] = dirs_blocks
  long_dirs
end

def dir_permission(file_stat)
  permission = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  dir_permission = ''
  octal_permission = file_stat.mode.to_s(8)
  (-3..-1).each do |i|
    dir_permission += permission[octal_permission[i, 1].to_i]
  end
  dir_permission = extra_permission(dir_permission, octal_permission)
end

def extra_permission(dir_permission, octal_permission)
  extra_permission = octal_permission[-4, 1].to_i.to_s(2)
  unless extra_permission == '0'
    extra_permission.size.times do |n|
      if n.zero?
        dir_permission[-1] = if dir_permission[-1] == 'x'
                               't'
                             else
                               'T'
                             end
      else
        dir_permission[-1 * 2 ^ (n + 1)] = if dir_permission[-1 * 2 ^ (n + 1)] == 'x'
                                             's'
                                           else
                                             'S'
                                           end
      end
    end
  end
  dir_permission
end

def display_long(dirs)
  long_dirs = long_format(dirs)
  puts "total #{long_dirs[:total_block]}"
  dirs.size.times do |i|
    print long_dirs[:file_type][i]
    print long_dirs[:permission][i]
    print long_dirs[:nlink][i].rjust(calc_padding(long_dirs[:nlink]))
    print long_dirs[:owner_name][i].rjust(calc_padding(long_dirs[:owner_name]))
    print long_dirs[:grop_name][i].rjust(calc_padding(long_dirs[:grop_name]))
    print long_dirs[:dir_size][i].rjust(calc_padding(long_dirs[:dir_size]))
    print long_dirs[:accses_time][i].rjust(calc_padding(long_dirs[:accses_time]))
    print dirs[i]
    print "\n"
  end
end

def display_dirs(dirs)
  dirs.size
  max_length = calc_padding(dirs)
  terminal_cols = `tput cols`.to_i
  output_rows = (dirs.size.to_f / (terminal_cols / max_length).floor).ceil
  output_rows.times do |row|
    row.step(dirs.size - 1, output_rows) do |col|
      print dirs[col].ljust(max_length)
    end
    print "\n"
  end
end

def calc_padding(string)
  string.max_by(&:length).length + 1
end

dirs_list
