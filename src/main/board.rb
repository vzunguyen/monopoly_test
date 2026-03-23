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
    if square.is_a?(Property)
      @squares << square
    elsif square.type == 'property'
      @squares << square.to_property
    else
      @squares << square
    end
  end

  def check_for_monopoly(player, colour)
    properties_of_colour = @squares.select { |square| square.is_a?(Property) && square.colour == colour }
    return properties_of_colour.all? { |property| property.is_owned_by?(player) }
  end

  def update_rent_for_monopoly(player, colour)
    if check_for_monopoly(player, colour)
      @squares.each do |square|
        if square.is_a?(Property) && square.colour == colour && square.is_owned_by?(player)
          square.rent *= 2
        end
      end
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
    if is_property?
      Property.new(name: @name, price: @price, colour: @colour, owner: @owner)
    else
      raise "Square #{@name} is not a property and cannot be converted to a Property object."
    end
  end
end