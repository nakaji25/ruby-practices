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
    padding = max_length(:name) + 1
    terminal_cols = `tput cols`.to_i
    output_rows = @entries.size.ceildiv((terminal_cols / padding).floor)
    output_rows.times do |row|
      row.step(@entries.size - 1, output_rows) do |col|
        print @entries[col].name.ljust(padding)
      end
      print "\n"
    end
  end

  def display_long
    puts "total #{@entries.sum(&:entry_blocks)}"
    paddings = generate_row_width
    @entries.each do |long_entry|
      print long_entry.permission
      print long_entry.nlink.to_s.rjust(paddings[:nlink] + 2)
      print long_entry.owner_name.rjust(paddings[:owner_name] + 1)
      print long_entry.group_name.rjust(paddings[:group_name] + 2)
      print long_entry.entry_size.to_s.rjust(paddings[:entry_size] + 2)
      print long_entry.access_time.strftime(' %_m %e %H:%M ')
      puts long_entry.name
    end
  end

  def generate_row_width
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
