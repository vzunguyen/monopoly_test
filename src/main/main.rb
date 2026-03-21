require 'json'
require 'ostruct'

def load_board(file_path)
  file_path = File.expand_path(file_path, __dir__)
  board_data = JSON.parse(File.read(file_path), object_class: OpenStruct)

  return board_data
end

def load_dice(file_path)
    file_path = File.expand_path(file_path, __dir__)
    dice_data = JSON.parse(File.read(file_path), object_class: OpenStruct)
    if dice_data.nil?
        puts "ERROR: Failed to load dice data"
        return nil
    else
        puts "DEBUG: Dice data successful: #{dice_data.inspect}"
        return dice_data
    end
end

# GAME LOOP
board = load_board("../data/board.json")
dice_data = load_dice("../data/rolls_1.json")

for square in board do
  puts "Square: #{square.name}, Type: #{square.type}"
end