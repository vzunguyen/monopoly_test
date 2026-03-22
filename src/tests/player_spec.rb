require 'rspec/autorun'
require_relative '../main/player'
require_relative '../main/board'

describe 'Player' do

  board = Board.new
  board.add_square(Square.new(name: 'Go', type: 'go'))
  board.add_square(Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown'))
  board.add_square(Square.new(name: 'Community Chest', type: 'community_chest'))

  describe '#initialize' do
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
    end

    it 'moves player to the beginning of board when reaching the end' do
      player = Player.new(name: 'Bob')
      player.move(3, board)
      expect(player.position).to eq(0)
    end

    it 'moves player around when moving more than the board length' do
      player = Player.new(name: 'Bob')
      player.move(5, board)
      expect(player.position).to eq(2)
    end
  end

  describe '#buy_property' do
    player = Player.new(name: 'Bob', money: 15)
    property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

    it 'buys property if player has enough money' do
      expect(player.buy_property(property)).to eq(true)
      expect(property.owner).to eq(player)
    end

    it 'gives player correct remaining money after buying property' do
      player.buy_property(property)
      expect(player.money).to eq(11)
    end

    it 'does not buy property if player does not have enough money' do
      player = Player.new(name: 'Bob', money: 1)
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(player.buy_property(property)).to eq(false)
      expect(property.owner).to be_nil
    end
  end
end