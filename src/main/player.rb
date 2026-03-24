require_relative 'property'

class Player
  attr_reader :name, :position, :is_bankrupt
  attr_accessor :money

  def initialize(name:, position: 0, money: 16)
    @name = name
    @position = position
    @money = money
    @is_bankrupt = false
  end

  def move(steps, board)
    times_passed_go, @position = (@position + steps).divmod(board.length)
    puts "MOVE: #{name} moved #{steps} steps to position #{@position} (#{board[@position].name})"
    times_passed_go if times_passed_go > 0
  end

  def buy_property(property)
    @money -= property.price
    property.owner = self
    puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
  end

  def pay_rent(property)
    if @money < property.rent
      property.owner.money += @money
      @money = 0
      @is_bankrupt = true
    else
      @money -= property.rent
      property.owner.money += property.rent
    end
    puts "PAY RENT: #{name} paid $#{property.rent}. #{property.owner.name}: $#{property.owner.money}. #{name}: $#{@money}."
  end
end
