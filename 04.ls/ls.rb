# frozen_string_literal: true

def gets_dir_list
  Dir.glob('*')
end

def display_dirs
  dir_list = gets_dir_list
  max_length = dir_list.max_by(&:length).length
  terminal_cols = `tput cols`.to_i
  output_rows = ((max_length * dir_list.size).to_f / terminal_cols).ceil
  (0..output_rows - 1).each do |row|
    row.step(dir_list.size - 1, output_rows) do |col|
      print dir_list[col].ljust(max_length + 1)
    end
    print "\n"
  end
end

display_dirs
