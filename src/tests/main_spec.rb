# frozen_string_literal: true
require 'rspec/autorun'
require_relative '../main/main'
require_relative '../main/board'
require_relative '../main/property'
require_relative '../main/go'

# TODO: Might need to put this as Integration test
describe 'In Main' do
  describe '#get_data_from' do
    it 'raises error if file does not exist' do
      expect { get_data_from('non_existent_file.json') }.to raise_error(Errno::ENOENT)
    end
  end
  describe '#load_board' do
    let(:board_data) do
      [
        OpenStruct.new(name: 'GO', type: 'go'),
        OpenStruct.new(name: 'The Burvale', type: 'property', price: 1, colour: 'Brown'),
        OpenStruct.new(name: 'Fast Kebabs', type: 'property', price: 1, colour: 'Brown')
      ]
    end
    let(:board) { load_board(board_data) }

    it 'returns a board object' do
      expect(board).to be_a(Board)
    end

    it 'adds correct object type to board' do
      expect(board[0]).to be_a(Go)
      expect(board[1]).to be_a(Property)
      expect(board[2]).to be_a(Property)
    end

    it 'raises error if object is not a Go or Property' do
      expect { load_board([OpenStruct.new(name: 'Chance', type: 'chance')]) }.to raise_error(RuntimeError)
    end
  end

  describe '#gain_money_passing_go' do
    let(:board) { Board.new }
    let(:player) { Player.new(name: 'Bob') }
    let(:go) { Go.new }

    before do
      board.add_square(go)
    end

    it 'returns 1 if player passes go once' do
      money_passed_go = player.move(1, board)
      gain_money_passing_go(player, money_passed_go)

      expect(player.money).to eq(17)
    end

    it 'returns 10 if player passes go 10 times' do
      money_passed_go = player.move(10, board)
      expect(money_passed_go).to eq(10)

      gain_money_passing_go(player, money_passed_go)
      expect(player.money).to eq(26)
    end

    it 'gained correct amount despite multiple moves' do
      money_passed_go = player.move(1, board)
      expect(money_passed_go).to eq(1)
      gain_money_passing_go(player, money_passed_go)


      money_passed_go = player.move(1, board)
      expect(money_passed_go).to eq(1)
      gain_money_passing_go(player, money_passed_go)

      expect(player.money).to eq(18)
    end
  end

end

