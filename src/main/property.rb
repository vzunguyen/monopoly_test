require_relative 'board'

class Property < Square
  attr_reader :name, :colour, :price
  attr_accessor :owner, :rent

  def initialize(name:, price:, colour:, rent: (price.to_f / 2).round(1), owner: nil)
    raise ArgumentError, "price can't be nil" if price.nil?
    raise ArgumentError, "colour can't be nil" if colour.nil?

    super(name: name, type: 'property')
    @price = price
    @rent = rent.to_f.round(1)
    @colour = colour
    @owner = owner
  end

  def is_owned?
    !@owner.nil?
  end

  def is_owned_by?(player)
    @owner == player
  end

  def is_rent_doubled?(board) # Potentially not needed
    board.check_for_monopoly(@owner, @colour)
  end
end

class Properties
  attr_reader :properties

  def initialize(properties: [])
    @properties = properties
  end

  def [](index)
    @properties[index]
  end

  def length
    @properties.length
  end

  def add_property(property)
    @properties << property
  end

  def has_property?(property)
    @properties.any? { |prop| prop.name == property.name }
  end
end
