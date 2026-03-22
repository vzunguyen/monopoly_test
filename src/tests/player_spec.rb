require 'rspec/autorun'
require_relative '../main/player'
require_relative '../main/board'

describe 'Player' do
  describe '#initialize' do
  board = Board.new
  board.add_square(Square.new(name: 'Go', type: 'go'))
  board.add_square(Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown'))
  board.add_square(Square.new(name: 'Community Chest', type: 'community_chest'))

    it 'initializes with default position 0 and money 16' do
      player = Player.new(name: 'Bob')
      expect(player.name).to eq('Bob')
      expect(player.position).to eq(0)
      expect(player.money).to eq(16)
    end
  end

  describe '#move' do
    it 'moves the player to the correct position on the board' do
      player = Player.new(name: 'Bob')
      player.move(2, board)
      expect(player.position).to eq(2)
      player.move(2, board)
      expect(player.position).to eq(0)
    end
  end
end