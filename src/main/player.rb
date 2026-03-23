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

        if @position < steps
            @money += 1
            puts "DEBUG: #{name} passed 'Go' and collected $1. Total money: $#{@money}"
        end
    end

    def buy_property(property, board)
        return false if property.nil? || !property.is_property?

        if property.is_owned?
            puts "\nCAN'T BUY #{property.name} (already owned by #{property.owner.name})"
            return false
        elsif @money >= property.price
            @money -= property.price
            property.owner = self
            property.is_rent_doubled?(board) ? property.price *= 2 : property.price
            puts "\nBUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
            return true
        else
            puts "\nNOT ENOUGH MONEY: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
            return false
        end
    end

    def pay_rent(property)
        if property.is_owned? && !property.is_owned_by?(self)
            rent = property.price
            @money -= rent
            property.owner.money += rent # TODO: Maybe add a method to Property to handle rent payment and ownership transfer logic instead of directly modifying the owner's money here
            puts "PAY RENT: #{name} paid $#{rent}. #{property.owner.name}: $#{property.owner.money}. #{name}: $#{@money}."
        end
    end

    def is_bankrupt?
        @money < 0
    end
end