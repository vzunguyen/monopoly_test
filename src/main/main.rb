# frozen_string_literal: true

require 'json'
require 'ostruct'
require_relative 'player'
require_relative 'board'
require_relative 'property'
require_relative 'square'
require_relative 'game_event'
require_relative 'go'

game_event = GameEvent.new

# Initialise players
players = [
  Player.new(name: 'Peter'),
  Player.new(name: 'Billy'),
  Player.new(name: 'Charlotte'),
  Player.new(name: 'Sweedal')
]

players.each { |player| puts "PLAYER ADDED: #{player.inspect}" }

def get_data_from(file_path)
  file_path = File.expand_path(file_path, __dir__)
  data = JSON.parse(File.read(file_path), object_class: OpenStruct)
  raise "ERROR: Failed to load data from #{file_path}" if data.nil?

  puts "DATA: Loaded data from #{file_path}"
  data
end

def load_board(data)
  board = Board.new
  data.each do |square|
    if square.type == 'property'
      board.add_square(Property.new(name: square.name, price: square.price, colour: square.colour))
    elsif square.type == 'go'
      board.add_square(Go.new)
    else
      raise "ERROR: Invalid square type: #{square.type}"
    end
  end
  board
end

def gain_money_passing_go(player, passed_go_count)
  return if passed_go_count == 0 || passed_go_count.nil?

  player.money += passed_go_count
  puts "GAIN MONEY AT GO: #{player.name} passed 'Go, gained $#{passed_go_count}. Total money: $#{player.money}"
end

# GAME LOOP
board = load_board(get_data_from('../data/board.json'))
dice = get_data_from('../data/rolls_1.json')

dice.each_with_index do |roll, index|
  raise 'ERROR: Dice rolls must be from 1 - 6' unless (1..6).cover?(roll)

  current_player = players[index % players.length]

  puts "\n--- TURN #{current_player.name} ---"

  # MOVE PLAYER
  times_passed_go = current_player.move(roll, board)
  gain_money_passing_go(current_player, times_passed_go)

  current_square = board[current_player.position]

  current_square.on_land(current_player, board)

  # END GAME IF BANKRUPTCY
  if current_player.is_bankrupt
    puts "\n#{current_player.name} is bankrupt!"
    break
  end
end

game_event.game_over_announcement(players, board)
