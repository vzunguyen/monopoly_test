require 'rspec/autorun'
require_relative '../main/board'
require_relative '../main/property'
require_relative '../main/player'

describe 'Board' do
  describe '#add_square' do
    it 'returns the correct square when added' do
      board = Board.new
      go_square = Square.new(name: 'Go', type: 'go')
      chance_square = Square.new(name: 'Chance', type: 'chance')
      board.add_square(go_square)
      board.add_square(chance_square)
      expect(board[0]).to eq(go_square)
      expect(board[1]).to eq(chance_square)
    end

    it 'returns nil if added square is not found' do
      board = Board.new
      expect(board[0]).to eq(nil)
    end

    it 'returns the correct length' do
      board = Board.new
      board.add_square(Square.new(name: 'Go', type: 'go'))
      board.add_square(Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown'))
      board.add_square(Square.new(name: 'Community Chest', type: 'community_chest'))
      expect(board.length).to eq(3)
    end

    it 'returns 0 if no squares are added' do
      board = Board.new
      expect(board.length).to eq(0)
    end
  end

  describe '#to_property' do
    it 'converts a property square to a Property object' do
      square = Square.new(name: 'Boardwalk', type: 'property', price: 400, colour: 'dark blue')
      property = square.to_property
      expect(property).to be_a(Property)
      expect(property.name).to eq('Boardwalk')
      expect(property.price).to eq(400)
      expect(property.colour).to eq('dark blue')
    end

    it 'raises an error when trying to convert a non-property square' do
      square = Square.new(name: 'Go', type: 'go')
      expect { square.to_property }.to raise_error(RuntimeError)
    end
  end

  describe '#check_for_monopoly' do
    board = Board.new
    player = Player.new(name: 'Bob')
    property1 = Property.new(name: 'Park Place', price: 2, colour: 'blue')
    property2 = Property.new(name: 'Boardwalk', price: 2, colour: 'blue')

    board.add_square(property1)
    board.add_square(property2)

    it 'it returns true if player has monopoly' do
      player.buy_property(property1, board)
      player.buy_property(property2, board)

      expect(property1.owner).to eq(player)
      expect(property2.owner).to eq(player)

      expect(board.check_for_monopoly(player, 'blue')).to eq(true)
    end

    it 'returns false if player does not have monopoly' do
      player2 = Player.new(name: 'Alice')
      expect(board.check_for_monopoly(player2, 'blue')).to eq(false)
    end
  end

  describe '#update_rent_for_monopoly' do
    board = Board.new
    player = Player.new(name: 'Bob')
    property1 = Property.new(name: 'Park Place', price: 2, colour: 'blue')
    property2 = Property.new(name: 'Boardwalk', price: 2, colour: 'blue')

    board.add_square(property1)
    board.add_square(property2)

    it 'updates rent for monopoly' do
      player.buy_property(property1, board)
      expect(property1.owner).to eq(player)
      expect(property1.rent).to eq(1)

      player.buy_property(property2, board)

      expect(property2.owner).to eq(player)
      expect(property1.rent).to eq(2)
      expect(property2.rent).to eq(2)
      end
  end
end

describe 'Square' do
  describe '#initialize' do
    it 'initializes with the Go square returning only name and type' do
      square = Square.new(name: 'Go', type: 'go')
      expect(square.name).to eq('Go')
      expect(square.type).to eq('go')
      expect(square.price).to eq(nil)
      expect(square.colour).to eq(nil)
    end

    it 'initializes with a property square returning name, type, price and colour' do
      square = Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown')
      expect(square.name).to eq('Mediterranean Avenue')
      expect(square.type).to eq('property')
      expect(square.price).to eq(60)
      expect(square.colour).to eq('brown')
    end

    it 'initializes with only name returning error' do
      expect { Square.new(name: 'Go') }.to raise_error(ArgumentError)
    end

    it 'initializes with only type returning error' do
      expect { Square.new(type: 'go') }.to raise_error(ArgumentError)
    end

    it 'initializes with nil name returning error' do
      expect { Square.new(name: nil, type: 'go') }.to raise_error(ArgumentError)
    end

    it 'initializes with nil type returning error' do
      expect { Square.new(name: 'Go', type: nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#is_property?' do
    it 'returns true if square is a property' do
      square = Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown')
      expect(square.is_property?).to eq(true)
    end

    it 'returns false if square is not a property' do
      square = Square.new(name: 'Go', type: 'go')
      expect(square.is_property?).to eq(false)
    end
  end

  describe '#to_property' do
    it 'returns a Property object if square is a property' do
      square = Square.new(name: 'Mediterranean Avenue', type: 'property', price: 60, colour: 'brown')
      property = square.to_property
      expect(property).to be_a(Property)
      expect(property.name).to eq('Mediterranean Avenue')
      expect(property.price).to eq(60)
      expect(property.colour).to eq('brown')
    end

    it 'raises error if square is not a property' do
      square = Square.new(name: 'Go', type: 'go')
      expect { square.to_property }.to raise_error(RuntimeError)
    end
  end
end
