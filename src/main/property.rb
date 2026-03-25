require_relative 'board'
require_relative 'square'

class Property < Square
  attr_reader :name, :colour, :price
  attr_accessor :owner, :rent, :is_rent_doubled

  def initialize(name:, price:, colour:, rent: (price.to_f / 2).round(1), owner: nil)
    raise ArgumentError, "price can't be nil" if price.nil?
    raise ArgumentError, "colour can't be nil" if colour.nil?

    super(name: name)
    @price = price
    @rent = rent.to_f.round(1)
    @colour = colour
    @owner = owner
    @is_rent_doubled = false
  end

  def is_owned?
    !@owner.nil?
  end

  def is_owned_by?(player)
    @owner == player
  end

  def on_land(current_player, board)
    # BUY PROPERTY
    unless is_owned?
      current_player.buy_property(self)
      board.update_rent_for_monopoly(current_player, @colour)
    end

    # PAY RENT
    return unless is_owned? && !is_owned_by?(current_player)
    amount_paid = current_player.pay_rent(self)
    @owner.receive_rent(amount_paid)
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
