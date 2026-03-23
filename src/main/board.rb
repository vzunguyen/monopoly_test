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
    if square.type == 'property'
      @squares << square.to_property
    else
      @squares << square
    end
  end

  def check_for_monopoly(player,colour)
    properties_of_colour = @squares.select { |square| square.is_a?(Property) && square.colour == colour }
    properties_owned_by_player = properties_of_colour.select { |property| property.is_owned_by?(player) }
    return properties_of_colour.length > 0 && properties_of_colour.length == properties_owned_by_player.length
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
    if is_property?
      Property.new(name: @name, price: @price, colour: @colour, owner: @owner)
    else
      raise "Square #{@name} is not a property and cannot be converted to a Property object."
    end
  end
end