# frozen_string_literal: true

class Display
  def initialize(entries)
    @entries = entries
  end

  def display_entries(long_option)
    long_option.nil? ? display_short : display_long
  end

  def display_short
    padding = max_length(@entries.map(&:name)) + 1
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
    puts "total #{@entries.map(&:entry_blocks).sum}"
    paddings = generate_paddings
    @entries.each do |long_entry|
      print long_entry.permission
      print long_entry.nlink.to_s.rjust(paddings[:nlink] + 1)
      print long_entry.owner_name.rjust(paddings[:owner_name] + 1)
      print long_entry.group_name.rjust(paddings[:group_name] + 2)
      print long_entry.entry_size.to_s.rjust(paddings[:entry_size] + 2)
      print long_entry.access_time.strftime('%_m %e %H:%M')
      puts long_entry.name
    end
  end

  private

  def generate_paddings
    {
      nlink: max_length(@entries.map { |d| d.send(:nlink).to_s }),
      owner_name: max_length(@entries.map(&:owner_name)),
      group_name: max_length(@entries.map(&:group_name)),
      entry_size: max_length(@entries.map { |d| d.send(:entry_size).to_s })
    }
  end

  def max_length(str)
    str.max.length
  end
end
