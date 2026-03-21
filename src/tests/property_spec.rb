require 'rspec/autorun'
require_relative '../main/property'

describe 'Property' do
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
end