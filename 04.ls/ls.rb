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
  long_dirs = dirs.map do |dir|
    long_dir = {}
    fs = File::Stat.new(dir)
    dirs_blocks += fs.blocks
    long_dir[:name] = dir
    long_dir[:file_type] = file_type[File.ftype(dir).to_sym]
    long_dir[:permission] = dir_permission(fs)
    long_dir[:nlink] = fs.nlink.to_s
    long_dir[:owner_name] = Etc.getpwuid(fs.uid).name
    long_dir[:grop_name] = Etc.getgrgid(fs.gid).name
    long_dir[:dir_size] = fs.size.to_s
    long_dir[:accses_time] = fs.atime.strftime('%_m %e %H:%M ')
    long_dir
  end
  [long_dirs, dirs_blocks]
end

def dir_permission(file_stat)
  permission = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  dir_permission = ''
  octal_permission = file_stat.mode.to_s(8)[-3, 3].split('')
  dir_permission = octal_permission.map { |n| permission[n.to_i] }.join
  dir_permission = extra_permission(dir_permission, octal_permission)
end

def extra_permission(dir_permission, octal_permission)
  extra_permission = octal_permission[-4, 1].to_i.to_s(2).rjust(3, '0')
  unless extra_permission == '000'
    if extra_permission[-1]
      dir_permission[-1] = dir_permission[-1] == 'x' ? 't' : 'T'
    end
    if extra_permission[-2]
      dir_permission[-4] = dir_permission[-4] == 'x' ? 's' : 'S'
    end
    if extra_permission[-3]
      dir_permission[-7] = dir_permission[-7] == 'x' ? 's' : 'S'
    end
  end
  dir_permission
end

def display_long(dirs)
  long_dirs, dirs_blocks = long_format(dirs)
  puts "total #{dirs_blocks}"
  long_dirs.each do |long_dir|
    print long_dir[:file_type]
    print long_dir[:permission]
    print long_dir[:nlink].rjust(calc_padding(long_dirs.map { |d| d[:nlink] }))
    print long_dir[:owner_name].rjust(calc_padding(long_dirs.map { |d| d[:owner_name] }))
    print long_dir[:grop_name].rjust(calc_padding(long_dirs.map { |d| d[:grop_name] }))
    print long_dir[:dir_size].rjust(calc_padding(long_dirs.map { |d| d[:dir_size] }))
    print long_dir[:accses_time].rjust(calc_padding(long_dirs.map { |d| d[:accses_time] }))
    puts long_dir[:name]
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
