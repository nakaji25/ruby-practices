# frozen_string_literal: true

require_relative 'base_directory'

class Directory < BaseDirectory
  def type(name)
    file_type = { fifo: 'p', characterSpecial: 'c', directory: 'd', blockSpecial: 'b', file: '-', link: 'l', socket: 's' }
    file_type[File.ftype(name).to_sym]
  end

  def dir_permission(dir_stat)
    permission = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
    octal_permission = dir_stat.mode.to_s(8)[-3, 3].split('')
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
end
