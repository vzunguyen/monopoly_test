require 'json'
require 'ostruct'
require_relative 'board'

def load_board(file_path)
  file_path = File.expand_path(file_path, __dir__)
  board_data = JSON.parse(File.read(file_path), object_class: OpenStruct)

  board = Board.new
    for square in board_data
            board.add_square(
                Square.new(
                    name: square.name,
                    type: square.type,
                    price: square.price,
                    colour: square.colour
                )
            )
    end

    return board
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

board.length.times do |index|
    square = board[index]
    puts "Square #{index}: #{square.name} (#{square.type})"
end