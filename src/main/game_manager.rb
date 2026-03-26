# frozen_string_literal: true `
require_relative 'dice/predefined_dice'

# Manages the game logic
class GameManager
  attr_reader :board, :players, :dice
  def initialize(board, players, dice)
    raise ArgumentError, 'ERROR: Board data is needed' if board.nil?
    raise ArgumentError, 'ERROR: Players data is needed' if players.nil? || players.empty?
    raise ArgumentError, 'ERROR: Dice data is needed' if dice.nil?
    @board = board
    @players = players
    @dice = dice
  end

  def play
    index = 0
    loop do
      current_player = players[index % players.length]

      puts "\n--- TURN #{current_player.name} ---"

      steps = dice.roll
      passed_go_count = current_player.move(steps, board)
      gain_money_passing_go(current_player, passed_go_count)

      current_square = board[current_player.position]
      current_square.on_land(current_player, board)
      break if game_is_over(current_player, dice)

      index += 1
    end
    players
  end

  def game_is_over(player, dice)
    if player.is_bankrupt
      puts "BANKRUPT: #{player.name} is bankrupt. Game over."
      return true
    end
    return true if dice.is_end?

    false
  end

  def gain_money_passing_go(player, passed_go_count)
    return if passed_go_count.nil? || passed_go_count.zero?

    player.money += passed_go_count
    puts "GAIN MONEY AT GO: #{player.name} passed 'Go, gained $#{passed_go_count}. Total money: $#{player.money}"
  end
end
