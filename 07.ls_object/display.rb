# frozen_string_literal: true

class Display
  def initialize(dirs)
    @dirs = dirs
  end

  def contents
    padding = max_length(:name) + 1
    terminal_cols = `tput cols`.to_i
    output_rows = (@dirs.size.to_f / (terminal_cols / padding).floor).ceil
    output_rows.times do |row|
      row.step(@dirs.size - 1, output_rows) do |col|
        print @dirs[col].name.ljust(padding)
      end
      print "\n"
    end
  end

  def long_contents
    puts "total #{@dirs.map(&:dir_blocks).sum}"
    @dirs.each do |dir|
      print dir.permission.rjust(max_length(:permission))
      print dir.nlink.rjust(max_length(:nlink) + 1)
      print dir.owner_name.rjust(max_length(:owner_name) + 1)
      print dir.group_name.rjust(max_length(:group_name) + 1)
      print dir.dir_size.rjust(max_length(:dir_size) + 1)
      print dir.accses_time.rjust(max_length(:accses_time) + 1)
      puts dir.name
    end
  end

  def max_length(key)
    @dirs.map(&key).max_by(&:length).length
  end
end
