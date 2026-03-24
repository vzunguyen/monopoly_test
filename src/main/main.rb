# frozen_string_literal: true

require 'json'
require 'ostruct'
require_relative 'player'
require_relative 'board'
require_relative 'property'
require_relative 'game_event'

game_event = GameEvent.new

# Initialise players
players = [
  Player.new(name: 'Peter'),
  Player.new(name: 'Billy'),
  Player.new(name: 'Charlotte'),
  Player.new(name: 'Sweedal')
]

players.each { |player| puts "DEBUG: #{player.inspect}" }

def load_board(file_path)
  file_path = File.expand_path(file_path, __dir__)
  board_data = JSON.parse(File.read(file_path), object_class: OpenStruct)

  board = Board.new
  board_data.each do |square|
    board.add_square(
      Square.new(
        name: square.name,
        type: square.type,
        price: square.price,
        colour: square.colour
      )
    )
  end

  board
end

def load_dice(file_path)
  file_path = File.expand_path(file_path, __dir__)
  dice_data = JSON.parse(File.read(file_path), object_class: OpenStruct)
  if dice_data.nil?
    puts 'ERROR: Failed to load dice data'
    nil
  else
    puts "DEBUG: Dice data successful: #{dice_data.inspect}"
    dice_data
  end
end

# GAME LOOP
board = load_board('../data/board.json')
dice = load_dice('../data/rolls_1.json')

turn_index = 0
dice.length.times do
  current_player = players[turn_index % players.length]

  steps = dice[turn_index]

  puts "\n--- TURN #{current_player.name} ---"

  # MOVE PLAYER
  current_player.move(steps, board)
  current_square = board[current_player.position]
  puts "MOVE: #{current_player.name} moved to position #{current_player.position} (#{current_square.name})"

  # BUY PROPERTY
  current_player.buy_property(current_square) if current_square.is_property?

  # PAY RENT
  current_player.pay_rent(current_square, board) if current_square.is_property?

  # END GAME IF BANKRUPTCY
  if current_player.is_bankrupt?
    puts "\n#{current_player.name} is bankrupt!"
    break
  end

  turn_index += 1
end

game_event.game_over_announcement(players, board)
