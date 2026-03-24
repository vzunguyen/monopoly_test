require 'rspec/autorun'
require_relative '../main/player'
require_relative '../main/board'
require_relative '../main/property'

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
    it 'buys property if player has enough money' do
      player = Player.new(name: 'Bob')
      broadwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      expect(player.buy_property(broadwalk_property)).to eq(true)
      expect(broadwalk_property.owner).to eq(player)
    end

    it 'gives player correct remaining money after buying property' do
      player = Player.new(name: 'Bob')
      broadwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      player.buy_property(broadwalk_property)
      expect(player.money).to eq(12)
    end

    it 'does not buy property if player does not have enough money' do
      player = Player.new(name: 'Bob', money: 15)
      expensive_property = Property.new(name: 'Park Place', price: 20, colour: 'dark blue')

      expect(player.buy_property(expensive_property)).to eq(false)
      expect(expensive_property.owner).to be_nil
    end
  end

  describe '#pay_rent' do
    it 'pays rent to property owner when landing on owned property' do
      player1 = Player.new(name: 'Bob')
      player2 = Player.new(name: 'Alice')
      broadwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      player1.buy_property(broadwalk_property)
      player2.pay_rent(broadwalk_property, board)

      expect(player2.money).to eq(14)
      expect(player1.money).to eq(14)
    end

    it 'does not pay rent if property is not owned' do
      player = Player.new(name: 'Bob')
      unowned_property = Property.new(name: 'Park Place', price: 20, colour: 'dark blue')

      player.pay_rent(unowned_property, board)
      expect(player.money).to eq(16)
    end

    it 'does not pay rent if landing on self-owned property' do
      player = Player.new(name: 'Bob')
      broadwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      player.buy_property(broadwalk_property)
      player.pay_rent(broadwalk_property, board)

      expect(player.money).to eq(12)
    end

    it 'doubles rent if property is part of a monopoly' do
      player1 = Player.new(name: 'Bob')
      player2 = Player.new(name: 'Alice')
      property1 = Property.new(name: 'Park Place', price: 2, colour: 'dark blue')
      property2 = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      board.add_square(property1)
      board.add_square(property2)

      player1.buy_property(property1, board)
      player1.buy_property(property2, board)

      player2.pay_rent(property1, board)

      expect(player2.money).to eq(15)
      expect(player1.money).to eq(11)
    end
  end

  describe '#is_bankrupt?' do
    it 'returns true if player has negative money' do
      player = Player.new(name: 'Bob', money: -1)
      expect(player.is_bankrupt?).to eq(true)
    end

    it 'returns false if player has zero or positive money' do
      player = Player.new(name: 'Bob', money: 0)
      expect(player.is_bankrupt?).to eq(false)

      player.money = 10
      expect(player.is_bankrupt?).to eq(false)
    end
  end
end
