# frozen_string_literal: true `
require_relative 'dice/predefined_dice'

class GameManager
  def initialize(board_data, players_data, dice_data)
    raise ArgumentError, 'ERROR: Board data is needed' if board_data.nil? || board_data.empty?
    raise ArgumentError, 'ERROR: Players data is needed' if players_data.nil? || players_data.empty?

    @board_data = board_data
    @players_data = players_data
    @dice_data = dice_data
  end

  def load_board
    board = Board.new
    @board_data.each do |square|
      if square['type'] == 'property'
        board.add_square(Property.new(name: square['name'], price: square['price'], colour: square['colour']))
      elsif square['type'] == 'go'
        board.add_square(Go.new)
      else
        raise "ERROR: Invalid square type: #{square['type']}"
      end
    end
    board
  end

  def load_players
    players = []
    @players_data.each do |player_data|
      # Only accepts name of the player
      raise 'ERROR: Wrong player data format' unless player_data.keys.map(&:to_s) == ['name']
      raise ArgumentError, "ERROR: Player name can't be empty" if player_data['name'].nil? || player_data['name'].empty?

      players << Player.new(name: player_data['name'])
    end
    players
  end

  def load_dice
    PredefinedDice.new(rolls_data: @dice_data)
  end

  def set_up
    board = load_board
    players = load_players
    predefined_dice = load_dice
    game_event = GameEvent.new

    [board, players, predefined_dice, game_event]
  end

  def play
    board, players, predefined_dice, game_event = set_up

    index = 0
    loop do
      current_player = players[index % players.length]

      puts "\n--- TURN #{current_player.name} ---"

      times_passed_go = current_player.move(predefined_dice.roll, board)
      gain_money_passing_go(current_player, times_passed_go)

      current_square = board[current_player.position]
      current_square.on_land(current_player, board)

      break if game_is_over(current_player, predefined_dice)

      index += 1
    end
    game_event.game_over_announcement(players, board)
  end

  def game_is_over(player, dice)
    return true if player.is_bankrupt
    return true if dice.is_end?

    false
  end

  def gain_money_passing_go(player, passed_go_count)
    return if passed_go_count == 0 || passed_go_count.nil?

    player.money += passed_go_count
    puts "GAIN MONEY AT GO: #{player.name} passed 'Go, gained $#{passed_go_count}. Total money: $#{player.money}"
  end
end
