# frozen_string_literal: true
require 'json'
require 'ostruct'
require_relative 'board'
require_relative 'square/property'
require_relative 'square/go'
require_relative 'player'
require_relative 'dice/predefined_dice'

class DataLoader
  def load_data_from(file_path)
    file_path = File.expand_path(file_path, __dir__)
    data = JSON.parse(File.read(file_path), object_class: OpenStruct)
    raise "ERROR: Failed to load data from #{file_path}" if data.nil?

    puts "DATA: Loaded data from #{file_path}"
    data
  end

  def load_board(file_path)
    board = Board.new
    load_data_from(file_path).each do |square|
      if square.type == 'property'
        board.add_square(Property.new(name: square['name'], price: square['price'], colour: square['colour']))
      elsif square.type == 'go'
        board.add_square(Go.new)
      else
        raise "ERROR: Invalid square type: #{square.type}"
      end
    end
    board
  end

  def load_players(file_path)
    players = []
    load_data_from(file_path).each do |player_data|
      raise ArgumentError, "ERROR: Player name can't be empty" if player_data.name.nil? || player_data.name.empty?

      players << Player.new(name: player_data.name)
    end
    players
  end

  def load_dice(file_path)
    PredefinedDice.new(rolls_data: load_data_from(file_path))
  end
end
