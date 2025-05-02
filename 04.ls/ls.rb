# frozen_string_literal: true

def dirs_list
  Dir.glob('*')
end

def display_dirs
  dirs = dirs_list
  max_length = dirs.max_by(&:length).length
  terminal_cols = `tput cols`.to_i
  output_rows = ((max_length * dirs.size).to_f / terminal_cols).ceil
  output_rows.times do |row|
    row.step(dirs.size - 1, output_rows) do |col|
      print dirs[col].ljust(max_length + 1)
    end
    print "\n"
  end
end

display_dirs
