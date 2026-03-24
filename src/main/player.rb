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

    return if times_passed_go.zero?

    @money += times_passed_go
    puts "GAIN MONEY AT GO: #{name} passed 'Go, gained $#{times_passed_go}. Total money: $#{@money}"
  end

  def buy_property(property, board)
    if property.is_owned?
      puts "CAN'T BUY #{property.name} (already owned by #{property.owner.name})"
      return false
    end
    if @money < property.price
      puts "NOT ENOUGH MONEY: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
      return false
    end
    @money -= property.price
    property.owner = self
    board.update_rent_for_monopoly(self, property.colour)
    puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
    true
  end

  def pay_rent(property)
    return unless property.is_owned? && !property.is_owned_by?(self)
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
