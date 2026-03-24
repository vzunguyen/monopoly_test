require 'rspec/autorun'
require_relative '../main/property'
require_relative '../main/board'
require_relative '../main/player'

describe 'Property' do
  describe '#initialize' do
    let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue') }

    it 'initializes with the correct name, price, and colour' do
      expect(property.name).to eq('Boardwalk')
      expect(property.price).to eq(4)
      expect(property.colour).to eq('dark blue')
      expect(property.owner).to eq(nil)
    end

    it 'initializes with the correct type' do
      expect(property.type).to eq('property')
    end

    it 'returns error if initialized with no price or colour' do
      expect { Property.new(name: 'ErrorProperty') }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', price: 4) }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with no name' do
      expect { Property.new(price: 400, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil name' do
      expect { Property.new(name: nil, price: 400, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil price' do
      expect { Property.new(name: 'ErrorProperty', price: nil, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil colour' do
      expect { Property.new(name: 'ErrorProperty', price: 400, colour: nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#is_owned?' do
    let(:board) { Board.new }

    it 'returns true if property is owned by any player' do
      owner = Player.new(name: 'Bob')
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      owner.buy_property(property, board)
      expect(property.owner).to eq(owner)

      expect(property.is_owned?).to eq(true)
    end

    it 'returns false if property is not owned by any player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(property.is_owned?).to eq(false)
    end
  end

  describe '#is_owned_by?' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob') }
    let(:alice) { Player.new(name: 'Alice') }

    it 'returns true if property is owned by the player' do
      owner = Player.new(name: 'Bob')
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      owner.buy_property(property, board)
      expect(property.owner).to eq(owner)
    end

    it 'returns false if property is not owned by any player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(property.is_owned_by?(bob)).to eq(false)
    end

    it 'returns false if property is owned by another player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      alice.buy_property(property, board)

      expect(property.is_owned_by?(bob)).to eq(false)
    end
  end

  describe '#is_rent_doubled?' do
    let(:board) { Board.new }

    before do
      board.add_square(Property.new(name: 'Park Place', price: 20, colour: 'dark blue'))
      board.add_square(Property.new(name: 'Boardwalk', price: 40, colour: 'dark blue'))
    end

    it 'returns true if player has monopoly' do
      owner = Player.new(name: 'Bob')
      player = Player.new(name: 'Alice')

      property1 = board[0]
      property2 = board[1]

      owner.buy_property(property1, board)
      owner.buy_property(property2, board)

      player.pay_rent(property1)
      player.pay_rent(property2)

      expect(property1.is_rent_doubled?(board)).to eq(true)
      expect(property2.is_rent_doubled?(board)).to eq(true)
    end
  end
end
