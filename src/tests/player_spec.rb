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

    before do
      board.add_square(Go.new)
      board.add_square(Property.new(name: 'Boardwalk', price: 4, colour: 'blue'))
      board.add_square(Property.new(name: 'Park Place', price: 4, colour: 'blue'))
    end

    it 'moves the player to the correct position on the board' do
      player = Player.new(name: 'Bob')
      money_passed_go = player.move(2, board)
      expect(player.position).to eq(2), 'Player position should be 2'
      expect(money_passed_go).to eq(0), 'Player should not receive money'
    end

    it 'moves player to the beginning of board when reaching the end of board' do
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
  end

  describe '#pay' do
    let(:player) { Player.new(name: 'Bob') }
    it 'if player has enough money, subtracts money from player' do
      before_payment = player.money
      payment = player.pay(10, true)
      expect(player.money).to eq(before_payment - payment)
    end

    it 'if player does not have enough money and not mandatory, does not subtract money from player' do
      before_payment = player.money
      payment = player.pay(18, false)
      expect(player.money).to eq(before_payment)
    end

    it 'if player does not have enough money and mandatory, subtract player money remaining and call bankrupt' do
      payment = player.pay(18, true)
      expect(player.money).to eq(0)
      expect(player.is_bankrupt).to eq(true)
    end
  end

  describe '#receive' do
    let(:player) { Player.new(name: 'Bob') }

    it 'adds money to player' do
      before_payment = player.money
      amount_to_add = 10
      player.receive(10)
      expect(player.money).to eq(before_payment + amount_to_add)
    end

    it 'does not add money to player if amount is zero, negative or nil' do
      before_payment = player.money
      player.receive(-10)
      expect(player.money).to eq(before_payment)

      player.receive(0)
      expect(player.money).to eq(before_payment)

      player.receive(nil)
      expect(player.money).to eq(before_payment)
    end
  end
end
