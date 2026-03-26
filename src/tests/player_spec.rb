require 'rspec/autorun'
require_relative '../main/player'
require_relative '../main/board'
require_relative '../main/square/property'
require_relative '../main/square/go'

describe 'Player' do
  describe '#initialize' do
    let(:bob) { Player.new(name: 'Bob') }

    it 'initializes with default position 0 and money 16' do
      expect(bob.name).to eq('Bob')
      expect(bob.position).to eq(0)
      expect(bob.money).to eq(16)
    end
  end

  describe '#move' do
    let(:board) { Board.new }
    let(:go) { Go.new }

    before do
      board.add_square(go)
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

    it 'returns the correct amount of money passed go' do
      player = Player.new(name: 'Bob')
      money_passed_go = player.move(board.length, board)
      expect(money_passed_go).to eq(1)
    end

    it 'returns nil when player passes go at the start' do
      player = Player.new(name: 'Bob')
      money_passed_go = player.move(1, board)

      expect(money_passed_go).to eq(nil)
    end
  end

  describe '#buy_property' do
    let(:board) { Board.new }
    let(:player) { Player.new(name: 'Bob') }

    it 'buys property if player has enough money' do
      boardwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      expect(player.buy_property(boardwalk_property)).to eq(true)
      expect(boardwalk_property.owner).to eq(player)
    end

    it 'gives player correct remaining money after buying property' do
      boardwalk_property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      player.buy_property(boardwalk_property)
      expect(player.money).to eq(12)
    end

    it 'does not buy property if player does not have enough money' do
      expensive_property = Property.new(name: 'Park Place', price: 20, colour: 'dark blue')

      expect(player.buy_property(expensive_property)).to eq(false)
      expect(expensive_property.owner).to be_nil
    end
  end

  describe '#pay_rent' do
    let(:board) { Board.new }
    let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
    let(:other_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }
    let(:bob) { Player.new(name: 'Bob') }
    let(:alice) { Player.new(name: 'Alice') }

    before do
      board.add_square(Go.new)
      board.add_square(owned_property)
      board.add_square(other_property)
    end

    context 'when property is owned by another player' do
      before do
        bob.buy_property(owned_property) # price = 4; rent = 2
      end

      it 'returns correct remaining money after paying rent' do
        expect(owned_property.owner).to eq(bob)
        expect(bob.money).to eq(12)

        alice.pay_rent(owned_property)

        expect(alice.money).to eq(14)
      end

      it 'not declares bankruptcy if player can afford rent' do
        alice.pay_rent(owned_property)
        expect(alice.is_bankrupt).to eq(false)
      end

      it 'declares bankruptcy if player cannot afford rent' do
        bob.money = 40
        alice.money = 10

        expensive_property = Property.new(name: 'Park Place', price: 30, colour: 'blue')

        bob.buy_property(expensive_property)
        alice.pay_rent(expensive_property)

        expect(alice.is_bankrupt).to eq(true)
      end

      context 'when is bankrupt' do
        before do
          bob.money = 40
          alice.money = 10
        end
        it 'pays owner the rest of the remaining money' do
          expensive_property = Property.new(name: 'Park Place', price: 30, colour: 'blue')

          bob.buy_property(expensive_property)
          amount_paid = alice.pay_rent(expensive_property)

          expect(amount_paid).to eq(10)
        end

        it 'player net worth returns 0' do
          expensive_property = Property.new(name: 'Park Place', price: 30, colour: 'blue')

          bob.buy_property(expensive_property)
          alice.pay_rent(expensive_property)

          expect(alice.money).to eq(0)
        end
      end
    end
  end

  describe '#receive_rent' do
    let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
    let(:player) { Player.new(name: 'Bob') }

    it 'returns correct amount of money received' do
      player.receive_rent(property.rent)
      expect(player.money).to eq(18)
    end
  end
end
