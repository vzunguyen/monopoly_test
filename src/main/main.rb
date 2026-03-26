# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'square/property'
require_relative 'square/square'
require_relative 'game_logger'
require_relative 'cli_parser'
require_relative 'game_manager'
require_relative 'data_loader'
require_relative 'dice/dice'
require_relative 'dice/predefined_dice'
require_relative 'square/go'

opts = CLIParser.new.parse(ARGV)

board = DataLoader.load_board(opts.board_file_path)
players = DataLoader.load_players(opts.players_file_path)
dice = DataLoader.load_dice(opts.dice_rolls_file_path)

game_manager = GameManager.new(board, players, dice)

players = game_manager.play

GameLogger.game_over_announcement(players, board)
