require_relative 'property'

class Player
  attr_reader :name, :position
  attr_accessor :money

  def initialize(name:, position: 0, money: 16)
    @name = name
    @position = position
    @money = money
  end

  def move(steps, board)
    @position = (@position + steps) % board.length

    return unless @position < steps

    @money += 1
    puts "GAIN $1: #{name} passed 'Go' and collected $1. Total money: $#{@money}"
  end

  def buy_property(property, board)
    return false if property.nil? || !property.is_property?

    if property.is_owned?
      puts "CAN'T BUY #{property.name} (already owned by #{property.owner.name})"
      false
    elsif @money >= property.price
      @money -= property.price
      property.owner = self
      board.update_rent_for_monopoly(self, property.colour)
      puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
      true
    else
      puts "NOT ENOUGH MONEY: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
      false
    end
  end

  def pay_rent(property)
    return unless property.is_owned? && !property.is_owned_by?(self)

    @money -= property.rent
    property.owner.money += property.rent
    puts "PAY RENT: #{name} paid $#{property.rent}. #{property.owner.name}: $#{property.owner.money}. #{name}: $#{@money}."
  end

  def is_bankrupt?
    @money < 0
  end
end
