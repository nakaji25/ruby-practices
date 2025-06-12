# frozen_string_literal: true

require 'etc'

class Entry
  attr_reader :name

  FILE_TYPE = { fifo: 'p', characterSpecial: 'c', directory: 'd', blockSpecial: 'b', file: '-', link: 'l', socket: 's' }.freeze
  PERMISSION = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  def initialize(entry_name)
    @name = entry_name
    @fs = File::Stat.new(entry_name)
  end

  def permission
    type + entry_permission
  end

  def type
    FILE_TYPE[File.ftype(@name).to_sym]
  end

  def entry_permission
    octal_permission = @fs.mode.to_s(8)[-3, 3].split('')
    nomal_permission = octal_permission.map { |n| PERMISSION[n.to_i] }.join
    extra_permission(nomal_permission)
  end

  def extra_permission(nomal_permission)
    extra_permission = @fs.mode.to_s(8)[-4, 1].to_i.to_s(2).rjust(3, '0')
    unless extra_permission == '000'
      if extra_permission[-1] == '1'
        nomal_permission[-1] = nomal_permission[-1] == 'x' ? 't' : 'T'
      end
      if extra_permission[-2] == '1'
        nomal_permission[-4] = nomal_permission[-4] == 'x' ? 's' : 'S'
      end
      if extra_permission[-3] == '1'
        nomal_permission[-7] = nomal_permission[-7] == 'x' ? 's' : 'S'
      end
    end
    nomal_permission
  end

  def nlink
    @fs.nlink
  end

  def owner_name
    Etc.getpwuid(@fs.uid).name
  end

  def group_name
    Etc.getgrgid(@fs.gid).name
  end

  def entry_size
    @fs.size
  end

  def accses_time
    @fs.atime
  end

  def entry_blocks
    @fs.blocks
  end
end
