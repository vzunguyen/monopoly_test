require 'rspec/autorun'
require_relative '../main/player'
require_relative '../main/board'
require_relative '../main/property'

describe 'Player' do
  describe '#initialize' do
    let(:player) { Player.new(name: 'Bob') }

    it 'initializes with default position 0 and money 16' do
      expect(player.name).to eq('Bob')
      expect(player.position).to eq(0)
      expect(player.money).to eq(16)
    end
  end

  describe '#move' do
    let(:board) { Board.new }

    before do
      board.add_square(Square.new(name: 'Go', type: 'go'))
      board.add_square(Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown'))
      board.add_square(Square.new(name: 'Community Chest', type: 'community_chest'))
      board.add_square(Property.new(name: 'Boardwalk', price: 4, colour: 'blue'))
      board.add_square(Property.new(name: 'Park Place', price: 4, colour: 'blue'))
    end

    it 'moves the player to the correct position on the board' do
      player = Player.new(name: 'Bob')
      player.move(2, board)
      expect(player.position).to eq(2)
    end

    it 'moves player to the beginning of board when reaching the end' do
      player = Player.new(name: 'Bob')
      player.move(board.length, board)
      expect(player.position).to eq(0)
    end

    it 'moves player around when moving more than the board length' do
      player = Player.new(name: 'Bob')
      player.move(board.length + 2, board)
      expect(player.position).to eq(2)
    end
  end

  describe '#buy_property' do
    let(:board) { Board.new }

    it 'buys property if player has enough money' do
      player = Player.new(name: 'Bob')
      boardwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      expect(player.buy_property(boardwalk_property, board)).to eq(true)
      expect(boardwalk_property.owner).to eq(player)
    end

    it 'gives player correct remaining money after buying property' do
      player = Player.new(name: 'Bob')
      boardwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      player.buy_property(boardwalk_property, board)
      expect(player.money).to eq(12)
    end

    it 'does not buy property if player does not have enough money' do
      player = Player.new(name: 'Bob', money: 15)
      expensive_property = Property.new(name: 'Park Place', price: 20, colour: 'dark blue')

      expect(player.buy_property(expensive_property, board)).to eq(false)
      expect(expensive_property.owner).to be_nil
    end

    it 'updates all properties rents when buy the last property in monopoly' do
      player = Player.new(name: 'Bob')
      property1 = Property.new(name: 'Park Place', price: 2, colour: 'dark blue')
      property2 = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      board.add_square(property1)
      board.add_square(property2)

      player.buy_property(property1, board)
      player.buy_property(property2, board)

      expect(property1.owner).to eq(player)
      expect(property2.owner).to eq(player)

      expect(property1.rent).to eq(2)
      expect(property2.rent).to eq(4)
    end
  end

  describe '#pay_rent' do
    let(:board) { Board.new }
    let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
    let(:other_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }
    let(:bob) { Player.new(name: 'Bob') }
    let(:alice) { Player.new(name: 'Alice') }

    before do
      board.add_square(Square.new(name: 'Go', type: 'go'))
      board.add_square(Square.new(name: 'Community Chest', type: 'community_chest'))
      board.add_square(owned_property)
      board.add_square(other_property)
    end

    context 'when property is owned by another player' do
      before do
        bob.buy_property(owned_property, board) # price = 4; rent = 2
      end

      it 'pays rent to property owner when landing on owned property' do
        expect(owned_property.owner).to eq(bob)
        expect(bob.money).to eq(12)

        alice.pay_rent(owned_property)

        expect(bob.money).to eq(14)
        expect(alice.money).to eq(14)
      end
    end

    it 'does not pay rent if property is not owned' do
      bob.pay_rent(other_property)
      expect(bob.money).to eq(16)
    end

    it 'does not pay rent if landing on self-owned property' do
      bob.buy_property(owned_property, board)

      bob.pay_rent(owned_property)
      expect(bob.money).to eq(12)
    end

    it 'doubles rent and returns correct amount of money to each player' do
      bob.buy_property(owned_property, board)
      bob.buy_property(other_property, board) # rent doubles after monopoly

      expect(other_property.owner).to eq(bob)
      expect(board.check_for_monopoly(bob, 'blue')).to eq(true)
      expect(bob.money).to eq(8)

      alice.pay_rent(other_property)
      expect(bob.money).to eq(12)
      expect(alice.money).to eq(12)
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
