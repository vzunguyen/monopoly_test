require_relative 'square/property'
class Board
  attr_reader :squares

  def initialize(squares: [])
    @squares = squares
  end

  def [](index)
    raise TypeError, "ERROR: Invalid index type: #{index.class}. Expected Integer." unless index.is_a?(Integer)
    raise IndexError, "ERROR: Index out of bounds: #{index}" if index < 0 || index >= @squares.length

    @squares[index]
  end

  def length
    @squares.length
  end

  def add_square(square)
    @squares << square
  end

  def check_for_monopoly(player, colour)
    properties_of_colour = @squares.select { |square| square.is_a?(Property) && square.colour == colour }
    properties_of_colour.all? { |property| property.is_owned_by?(player) }
  end

  def update_rent_for_monopoly(player, colour)
    return unless check_for_monopoly(player, colour)

    @squares.each do |square|
      if square.is_a?(Property) && square.colour == colour && !square.is_rent_doubled
        square.rent *= 2
        square.is_rent_doubled = true
      end
    end
    puts "RENT DOUBLED: #{player.name} has monopoly in #{colour}."
  end
end
