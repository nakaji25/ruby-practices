# frozen_string_literal: true

class Display
  def initialize(entries)
    @entries = entries
  end

  def display_entries(long_format: false)
    long_format ? display_long : display_short
  end

  private

  def display_short
    col_width = max_length(:name) + 1
    terminal_cols = `tput cols`.to_i
    output_rows = @entries.size.ceildiv((terminal_cols / col_width).floor)
    output_rows.times do |row|
      row.step(@entries.size - 1, output_rows) do |col|
        print @entries[col].name.ljust(col_width)
      end
      print "\n"
    end
  end

  def display_long
    puts "total #{@entries.sum(&:entry_blocks)}"
    col_widths = generate_col_widths
    @entries.each do |entry|
      print entry.permission
      print entry.nlink.to_s.rjust(col_widths[:nlink] + 2)
      print entry.owner_name.rjust(col_widths[:owner_name] + 1)
      print entry.group_name.rjust(col_widths[:group_name] + 2)
      print entry.entry_size.to_s.rjust(col_widths[:entry_size] + 2)
      print entry.access_time.strftime(' %_m %e %H:%M ')
      puts entry.name
    end
  end

  def generate_col_widths
    {
      nlink: max_length(:nlink),
      owner_name: max_length(:owner_name),
      group_name: max_length(:group_name),
      entry_size: max_length(:entry_size)
    }
  end

  def max_length(key)
    @entries.map { |e| e.send(key).to_s.size }.max
  end
end
