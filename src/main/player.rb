require_relative 'square/property'

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
    times_passed_go
  end

  def buy_property(property)
    return false if @money < property.price

    @money -= property.price
    property.owner = self
    puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
    true
  end

  def pay_rent(property)
    amount_to_pay = property.rent
    if @money < property.rent
      amount_to_pay = @money
      @money = 0
      @is_bankrupt = true
    else
      @money -= property.rent
    end
    puts "PAY RENT: #{name} paid $#{amount_to_pay}."
    amount_to_pay
  end

  def receive_rent(rent)
    @money += rent
    puts "RECEIVE RENT: #{name} received $#{rent}."
  end
end
