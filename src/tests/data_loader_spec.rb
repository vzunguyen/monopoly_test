# frozen_string_literal: true

require_relative '../main/data_loader'

describe 'Data Loader' do
  describe '#load_board' do
    let(:data_loader) { DataLoader.new }

    it 'loads board data into a Board object' do
      board = data_loader.load_board('../tests/test_data/board_valid_data.json')
      expect(board).to be_a(Board)
      expect(board.squares[0]).to be_a(Go)
      expect(board.squares[1]).to be_a(Property)
      expect(board.squares[2]).to be_a(Property)
    end

    it 'raises error if there is invalid type in board data' do
      expect {
        data_loader.load_board('../tests/test_data/board_invalid_data.json')
      }.to raise_error(RuntimeError,
                       /ERROR: Invalid square type/)
    end
  end

  describe '#load_players' do
    let(:data_loader) { DataLoader.new }

    it 'loads players data into the correct players' do
      players = data_loader.load_players('../tests/test_data/players_valid_data.json')
      expect(players.length).to eq(2)

      expect(players[0]).to be_a(Player)
      expect(players[0]).to have_attributes(name: 'Bob', money: 16, position: 0)

      expect(players[1]).to be_a(Player)
      expect(players[1]).to have_attributes(name: 'Alice', money: 16, position: 0)
    end

    it 'raises error if there is no name in players data' do
      expect {
        data_loader.load_players('../tests/test_data/players_invalid_data.json')
      }.to raise_error(ArgumentError,
                       /ERROR: Player name can't be empty/)
    end
  end

  describe '#load_dice' do
    let(:data_loader) { DataLoader.new }

    it 'loads dice data into a PredefinedDice object' do
      dice = data_loader.load_dice('../tests/test_data/rolls_valid_data.json')
      expect(dice).to be_a(PredefinedDice)
    end

    it 'loads correct rolls order' do
      dice = data_loader.load_dice('../tests/test_data/rolls_valid_data.json')
      expect(dice.roll).to eq(1)
      expect(dice.roll).to eq(2)
      expect(dice.roll).to eq(3)
      expect(dice.roll).to eq(4)
      expect(dice.roll).to eq(5)
      expect(dice.roll).to eq(6)
    end
  end
end
