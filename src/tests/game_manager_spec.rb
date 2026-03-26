# frozen_string_literal: true
require 'rspec/autorun'
require_relative '../main/game_manager'
require_relative '../main/board'
require_relative '../main/go'
require_relative '../main/property'
require_relative '../main/player'

describe 'Game Manager' do
  BOARD_DATA = [
    { "name" => "GO", "type" => "go" },
    { "name" => "The Burvale", "type" => "property", "price" => 1, "colour" => "Brown" },
    { "name" => "Fast Kebabs", "type" => "property", "price" => 1, "colour" => "Brown" }
  ]
  PLAYERS_DATA = [
    { "name" => "Bob" },
    { "name" => "Alice" }
  ]

  describe '#initialize' do
    it 'initializes with board data and players data' do
      game_manager = GameManager.new(BOARD_DATA, PLAYERS_DATA)
      expect(game_manager.instance_variable_get(:@board_data)).to eq(BOARD_DATA)
      expect(game_manager.instance_variable_get(:@players_data)).to eq(PLAYERS_DATA)
    end

    it 'raises ArgumentError if board data is nil' do
      expect { GameManager.new(nil, PLAYERS_DATA) }.to raise_error(ArgumentError, /ERROR: Board data is needed/)
    end

    it 'raises ArgumentError if players data is nil' do
      expect { GameManager.new(BOARD_DATA, nil) }.to raise_error(ArgumentError, /ERROR: Players data is needed/)
    end

    it 'raises ArgumentError if board data is empty' do
      expect { GameManager.new([], PLAYERS_DATA) }.to raise_error(ArgumentError, /ERROR: Board data is needed/)
    end

    it 'raises ArgumentError if players data is empty' do
      expect { GameManager.new(BOARD_DATA, []) }.to raise_error(ArgumentError, /ERROR: Players data is needed/)
    end
  end

  describe '#load_board' do
    let(:game_manager) { GameManager.new(BOARD_DATA, PLAYERS_DATA) }

    before do
      @board = game_manager.load_board
    end
    it 'loads board data into a Board object' do
      expect(@board).to be_a(Board)
    end

    it 'loads correct square Go type' do
      expect(@board.squares[0]).to be_a(Go)
    end

    it 'loads correct square Property type' do
      expect(@board.squares[1]).to be_a(Property)
      expect(@board.squares[2]).to be_a(Property)
    end

    it 'raises error if there is invalid type in board data' do
      invalid_board_data = [
        { "name" => "GO", "type" => "invalid" },
        { "name" => "The Burvale", "type" => "property", "price" => 1, "colour" => "Brown" },
        { "name" => "Fast Kebabs", "type" => "property", "price" => 1, "colour" => "Brown" }
      ]

      invalid_game_manager = GameManager.new(invalid_board_data, PLAYERS_DATA)
      expect { invalid_game_manager.load_board }.to raise_error(RuntimeError, /ERROR: Invalid square type/)
    end
  end

  describe '#load_players' do
    let(:game_manager) { GameManager.new(BOARD_DATA, PLAYERS_DATA) }
    let(:players) { game_manager.load_players }

    it 'loads players data into a Player object' do
      expect(players.first).to be_a(Player)
    end

    it 'raises error if there is invalid type in players data' do
      invalid_players_data = [
        { "name" => "Bob" },
        { "name" => "Alice", "type" => "invalid" }
      ]

      invalid_game_manager = GameManager.new(BOARD_DATA, invalid_players_data)
      expect { invalid_game_manager.load_players }.to raise_error(RuntimeError, /ERROR: Wrong player data format/)
    end

    it 'raises error if there is no name in players data' do
      invalid_players_data = [
        { "name" => nil },
        { "name" => "Alice" }
      ]
      end
  end
end
