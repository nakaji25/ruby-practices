# frozen_string_literal: true

class Display
  def initialize(entries)
    @entries = entries
  end

  def display_entries
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
    long_entries = format_long
    paddings = generate_paddings(long_entries)
    long_entries.each do |long_entry|
      line = long_entry.map do |key, value|
        if key == :name
          value
        elsif %i[nlink grop_name dir_size].include?(key)
          value.rjust(paddings[key] + 1)
        else
          value.rjust(paddings[key])
        end
      end.join(' ')
      puts line
    end
  end

  private

  def format_long
    @entries.map do |entry|
      {
        permission: entry.permission,
        nlink: entry.nlink.to_s,
        owner_name: entry.owner_name,
        grop_name: entry.group_name,
        dir_size: entry.entry_size.to_s,
        access_time: entry.access_time.strftime('%_m %e %H:%M'),
        name: entry.name
      }
    end
  end

  def generate_paddings(long_entries)
    {
      permission: max_length(long_entries.map { |d| d[:permission] }),
      nlink: max_length(long_entries.map { |d| d[:nlink] }),
      owner_name: max_length(long_entries.map { |d| d[:owner_name] }),
      grop_name: max_length(long_entries.map { |d| d[:grop_name] }),
      dir_size: max_length(long_entries.map { |d| d[:dir_size] }),
      access_time: max_length(long_entries.map { |d| d[:access_time] }),
      name: 0
    }
  end

  def max_length(str)
    str.max_by(&:length).length
  end
end
