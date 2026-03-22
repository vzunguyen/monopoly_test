require 'json'
require 'ostruct'
require_relative 'player'
require_relative 'board'
require_relative 'property'

# Initialise players
players = [
    Player.new(name: "Peter"),
    Player.new(name: "Billy"),
    Player.new(name: "Charlotte"),
    Player.new(name: "Sweedal")
]

players.each { |player| puts "DEBUG: #{player.inspect}" }

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
dice = load_dice("../data/rolls_1.json")

turn_index = 0
dice.length.times do
  current_player = players[turn_index % players.length]
  steps = dice[turn_index]

  # MOVE PLAYER
  current_player.move(steps, board)
  puts "DEBUG: #{current_player.name} moved to position #{current_player.position} (#{board[current_player.position].name})"

  # BUY PROPERTY
  current_player.buy_property(board[current_player.position]) if board[current_player.position].is_property?
  puts "DEBUG: #{current_player.name} has $#{current_player.money} remaining"

  # PAY RENT
  current_player.pay_rent(board[current_player.position]) if board[current_player.position].is_property?

  # END GAME IF BANKRUPTCY
  if current_player.is_bankrupt?
    puts "GAME OVER: #{current_player.name} is bankrupt!"
    puts "DEBUG: Final state of players:"
    players.each { |player| puts "#{player.name}: $#{player.money}" }
    players.each { |player| puts "#{player.name} on position #{player.position} (#{board[player.position].name})" }
    break
  end
  
  turn_index += 1
end

