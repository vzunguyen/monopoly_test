require 'rspec/autorun'
require_relative '../main/property'
require_relative '../main/board'

describe 'Property' do
  board = Board.new
  
  it 'initializes with the correct name, price, and colour' do
    property = Property.new(name: 'Boardwalk', price: 400, colour: 'dark blue')
    expect(property.name).to eq('Boardwalk')
    expect(property.price).to eq(400)
    expect(property.colour).to eq('dark blue')
    expect(property.owner).to eq(nil)
  end

  it 'initializes with the correct type' do
    property = Property.new(name: 'Boardwalk', price: 400, colour: 'dark blue')
    expect(property.type).to eq('property')
  end

  it 'returns error if initialized with no price or colour' do
    expect { Property.new(name: 'Boardwalk') }.to raise_error(ArgumentError)
    expect { Property.new(name: 'Boardwalk', price: 400) }.to raise_error(ArgumentError)
    expect { Property.new(name: 'Boardwalk', colour: 'blue') }.to raise_error(ArgumentError)
  end 

  it 'returns error if initialized with no name' do
    expect { Property.new(price: 400, colour: 'blue') }.to raise_error(ArgumentError)
  end

  it 'returns error if initialized with nil name' do
    expect { Property.new(name: nil, price: 400, colour: 'blue') }.to raise_error(ArgumentError)
  end

  it 'returns error if initialized with nil price' do
    expect { Property.new(name: 'Boardwalk', price: nil, colour: 'blue') }.to raise_error(ArgumentError)
  end

  it 'returns error if initialized with nil colour' do
    expect { Property.new(name: 'Boardwalk', price: 400, colour: nil) }.to raise_error(ArgumentError)
  end

  # describe '#is_owned?' do
    
  # end

  # describe '#is_owned_by?' do
    
  # end

  describe '#is_rent_doubled?' do
    it 'check monopoly and doubles rent if player has monopoly' do
      owner = Player.new(name: 'Bob')
      player = Player.new(name: 'Alice')
      property1 = Property.new(name: 'Park Place', price: 20, colour: 'dark blue')
      property2 = Property.new(name: 'Boardwalk', price: 40, colour: 'dark blue')

      board.add_square(property1)
      board.add_square(property2)

      owner.buy_property(property1)
      owner.buy_property(property2)

      player.pay_rent(property1, board)
      player.pay_rent(property2, board)

      expect(property1.is_rent_doubled?(board)).to eq(true)
      expect(property2.is_rent_doubled?(board)).to eq(true)
    end
  end
end