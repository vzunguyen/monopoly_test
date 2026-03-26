# frozen_string_literal: true
require_relative '../main/data_loader'

describe 'Data Loader' do
  let(:data_loader) { DataLoader.new }
  describe '#load_data_from' do
    it 'returns array of OpenStruct objects when loading data from a board file' do
      data = data_loader.load_data_from('../data/board.json')
      expect(data).to be_an(Array)
      expect(data.first).to be_a(OpenStruct)
    end

    it 'returns array of OpenStruct objects when loading players from a valid JSON file' do
      data = data_loader.load_data_from('../data/players.json')
      expect(data).to be_an(Array)
      expect(data.first).to be_a(OpenStruct)
    end

    it 'returns array of integers when loading dice rolls from a valid JSON file' do
      data = data_loader.load_data_from('../data/rolls_1.json')
      expect(data).to be_an(Array)
      expect(data.first).to be_an(Integer)
    end

    it 'raises error when loading data from an invalid JSON file' do
      expect { data_loader.load_data_from('../data/non_existent_file.json') }.to raise_error(Errno::ENOENT)
    end
  end

  describe '#load_board' do
    let(:data_loader) { DataLoader.new }
    let(:board) { data_loader.load_board('../tests/test_data/board_valid_data.json') }

    it 'loads board data into a Board object' do
      expect(board).to be_a(Board)
    end

    it 'loads correct square Go type' do
      expect(board.squares[0]).to be_a(Go)
    end

    it 'loads correct square Property type' do
      expect(board.squares[1]).to be_a(Property)
      expect(board.squares[2]).to be_a(Property)
    end

    it 'raises error if there is invalid type in board data' do
      expect { data_loader.load_board('../tests/test_data/board_invalid_data.json') }.to raise_error(RuntimeError, /ERROR: Invalid square type/)
    end
  end

  describe '#load_players' do
    let(:data_loader) { DataLoader.new }
    let(:players) { data_loader.load_players('../tests/test_data/players_valid_data.json') }

    it 'loads players data into a Player object' do
      expect(players.first).to be_a(Player)
    end

    it 'raises error if there is no name in players data' do
      expect { data_loader.load_players('../tests/test_data/players_invalid_data.json') }.to raise_error(ArgumentError, /ERROR: Player name can't be empty/)
    end
  end

  describe '#load_dice' do
    let(:data_loader) { DataLoader.new }
    let(:dice) { data_loader.load_dice('../tests/test_data/rolls_valid_data.json') }

    it 'loads dice data into a PredefinedDice object' do
      expect(dice).to be_a(PredefinedDice)
    end

    it 'loads correct rolls order' do
      expect(dice.roll).to eq(1)
      expect(dice.roll).to eq(2)
      expect(dice.roll).to eq(3)
      expect(dice.roll).to eq(4)
      expect(dice.roll).to eq(5)
      expect(dice.roll).to eq(6)
    end
  end
end
