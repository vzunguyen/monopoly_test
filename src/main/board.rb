class Board
  attr_reader :squares

  def initialize(squares: [])
    @squares = squares
  end

  def [](index)
    @squares[index]
  end

  def length
    @squares.length
  end

  def add_square(square)
    @squares << if square.is_a?(Property)
                  square
                elsif square.type == 'property'
                  square.to_property
                else
                  square
                end
  end

  def check_for_monopoly(player, colour)
    properties_of_colour = @squares.select { |square| square.is_a?(Property) && square.colour == colour }
    properties_of_colour.all? { |property| property.is_owned_by?(player) }
  end

  def update_rent_for_monopoly(player, colour)
    return unless check_for_monopoly(player, colour)

    @squares.each do |square|
      square.rent *= 2 if square.is_a?(Property) && square.colour == colour && square.is_owned_by?(player)
    end
  end
end

class Square
  attr_reader :name, :type, :price, :colour

  def initialize(name:, type:, price: nil, colour: nil)
    raise ArgumentError, "name can't be nil" if name.nil?
    raise ArgumentError, "type can't be nil" if type.nil?

    @name = name
    @type = type
    @price = price
    @colour = colour
  end

  def is_property?
    @type == 'property'
  end

  def to_property
    raise "Square #{@name} is not a property and cannot be converted to a Property object." unless is_property?

    Property.new(name: @name, price: @price, colour: @colour, owner: @owner)
  end
end
