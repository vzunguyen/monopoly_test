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
end

class Square
  attr_reader :name, :type, :price, :colour

  def initialize(name:, type:, price: nil, colour: nil)
    @name = name
    @type = type
    @price = price
    @colour = colour
  end
end