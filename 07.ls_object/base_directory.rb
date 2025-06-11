# frozen_string_literal: true

require 'etc'
class BaseDirectory
  attr_reader :name

  def initialize(name)
    @name = name
    @fs = File::Stat.new(name)
  end

  def permission
    type(@name) + dir_permission(@fs)
  end

  def nlink
    @fs.nlink.to_s
  end

  def owner_name
    Etc.getpwuid(@fs.uid).name
  end

  def group_name
    Etc.getgrgid(@fs.gid).name
  end

  def dir_size
    @fs.size.to_s
  end

  def accses_time
    @fs.atime.strftime('%_m %e %H:%M ')
  end

  def dir_blocks
    @fs.blocks
  end
end
