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
    fs = File::Stat.new(dir)
    dirs_blocks += fs.blocks
    {
      permission: file_type[File.ftype(dir).to_sym] + dir_permission(fs),
      nlink: fs.nlink.to_s,
      owner_name: Etc.getpwuid(fs.uid).name,
      grop_name: Etc.getgrgid(fs.gid).name,
      dir_size: fs.size.to_s,
      accses_time: fs.atime.strftime('%_m %e %H:%M '),
      name: dir
    }
  end
  [long_dirs, dirs_blocks]
end

def dir_permission(file_stat)
  permission = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
  octal_permission = file_stat.mode.to_s(8)[-3, 3].split('')
  dir_permission = octal_permission.map { |n| permission[n.to_i] }.join
  extra_permission(dir_permission, octal_permission)
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
    line = long_dir.map do |key, value|
      if key == :name
        value
      else
        value.rjust(max_length(long_dirs.map { |d| d[key] }))
      end
    end.join(' ')
    puts line
  end
end

def display_dirs(dirs)
  dirs.size
  padding = max_length(dirs) + 1
  terminal_cols = `tput cols`.to_i
  output_rows = (dirs.size.to_f / (terminal_cols / padding).floor).ceil
  output_rows.times do |row|
    row.step(dirs.size - 1, output_rows) do |col|
      print dirs[col].ljust(padding)
    end
    print "\n"
  end
end

def max_length(string)
  string.max_by(&:length).length
end

dirs_list
