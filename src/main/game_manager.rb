# frozen_string_literal: true

class GameManager
  def initialize(board_data, players_data)
    @board_data = board_data
    @players_data = players_data
  end

  def load_board
    board = Board.new
    @board_data.each do |square|
      if square["type"] == 'property'
        board.add_square(Property.new(name: square["name"], price: square["price"], colour: square["colour"]))
      elsif square["type"] == 'go'
        board.add_square(Go.new)
      else
        raise "ERROR: Invalid square type: #{square.type}"
      end
    end
    board
  end

  def load_players
    players = []
    @players_data.each do |player_data|
      players << Player.new(name: player_data["name"])
    end
    players
  end

  # def load_dice_rolls
  #   dice_rolls.map { |roll| roll.to_i }
  #   dice_rolls
  # end
end

