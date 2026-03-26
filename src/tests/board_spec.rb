require 'rspec'
require_relative '../main/board'
require_relative '../main/square/property'
require_relative '../main/player'
require_relative '../main/square/go'
require_relative '../main/square/square'

describe 'Board' do
  describe '[index]' do
    let(:board) { Board.new }
    let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue') }
    let(:go) { Go.new }

    before do
      board.add_square(go)
      board.add_square(owned_property)
    end

    it 'returns the correct square' do
      expect(board[0]).to eq(go)
      expect(board[1]).to eq(owned_property)
    end

    it 'raises error if index is out of range' do
      expect { board[2] }.to raise_error(IndexError)
    end

    it 'raises error if index is negative' do
      expect { board[-1] }.to raise_error(IndexError)
    end

    it 'raises error if index is not an integer' do
      expect { board['a'] }.to raise_error(TypeError)
    end

    it 'raises error if index is nil' do
      expect { board[nil] }.to raise_error(TypeError)
    end
  end

  describe '#add_square' do
    let(:board) { Board.new }
    let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue') }
    let(:go) { Go.new }

    it 'adds a property to the board' do
      board.add_square(owned_property)
      expect(board.squares[0]).to eq(owned_property)
    end

    it 'adds a go to the board' do
      board.add_square(go)
      expect(board.squares[0]).to eq(go)
    end

    it 'adds a property and a go to the board' do
      board.add_square(owned_property)
      board.add_square(go)

      expect(board.squares[0]).to eq(owned_property)
      expect(board.squares[1]).to eq(go)
    end
  end

  describe '#check_for_monopoly' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob') }
    let(:property1) { Property.new(name: 'Park Place', price: 2, colour: 'blue') }
    let(:property2) { Property.new(name: 'Boardwalk', price: 2, colour: 'blue') }

    before do
      board.add_square(property1)
      board.add_square(property2)
    end

    it 'it returns true if player has monopoly' do
      bob.buy_property(property1)
      bob.buy_property(property2)

      expect(property1.owner).to eq(bob)
      expect(property2.owner).to eq(bob)

      expect(board.check_for_monopoly(bob, 'blue')).to eq(true)
    end

    it 'it returns false if each player has a property of same colour' do
      alice = Player.new(name: 'Alice')

      bob.buy_property(property1)
      alice.buy_property(property2)

      expect(property1.owner).to eq(bob)
      expect(property2.owner).to eq(alice)

      expect(board.check_for_monopoly(bob, 'blue')).to eq(false)
    end

    it 'returns false if player does not have monopoly' do
      alice = Player.new(name: 'Alice')
      expect(board.check_for_monopoly(alice, 'blue')).to eq(false)
    end

    it 'returns true if board only has one property of one colour' do
      pink_property = Property.new(name: 'Pink Property', price: 2, colour: 'pink')
      board.add_square(pink_property)
      bob.buy_property(pink_property)

      expect(board.check_for_monopoly(bob, 'pink')).to eq(true)
    end
  end

  describe '#update_rent_for_monopoly' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob') }
    let(:property1) { Property.new(name: 'Park Place', price: 2, colour: 'blue') }
    let(:property2) { Property.new(name: 'Boardwalk', price: 2, colour: 'blue') }

    before do
      board.add_square(property1)
      board.add_square(property2)
    end

    it 'do not double rent for non-monopoly' do
      bob.buy_property(property1)
      board.update_rent_for_monopoly(bob, 'blue')

      expect(property1.owner).to eq(bob)
      expect(property1.rent).to eq(1)
    end

    it 'doubles rent for all properties in monopoly' do
      bob.buy_property(property1)
      bob.buy_property(property2)
      board.update_rent_for_monopoly(bob, 'blue')

      expect(property2.owner).to eq(bob)
      expect(property1.rent).to eq(2)
      expect(property2.rent).to eq(2)
    end
  end
end
