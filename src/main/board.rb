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
    @squares << square
  end

  def check_for_monopoly(player, colour)
    properties_of_colour = @squares.select { |square| square.is_a?(Property) && square.colour == colour }
    properties_of_colour.all? { |property| property.is_owned_by?(player) }
  end

  def update_rent_for_monopoly(player, colour)
    return unless check_for_monopoly(player, colour)

    @squares.each do |square|
      square.rent *= 2 if square.is_a?(Property) && square.colour == colour
    end
    puts "RENT DOUBLED: #{player.name} has monopoly in #{colour}."
  end
end
