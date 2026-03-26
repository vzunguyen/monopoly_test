# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'square/property'
require_relative 'square/square'
require_relative 'game_event'
require_relative 'cli_parser'
require_relative 'game_manager'
require_relative 'data_loader'
require_relative 'dice/dice'
require_relative 'dice/predefined_dice'
require_relative 'square/go'

GameEvent.new
data_loader = DataLoader.new

opts = CLIParser.new.parse(ARGV)
board_data = data_loader.load_data_from(opts.board_file_path)
players_data = data_loader.load_data_from(opts.players_file_path)
dice = data_loader.load_data_from(opts.dice_rolls_file_path)

game_manager = GameManager.new(board_data, players_data, dice)

game_manager.play
