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

    def buy_property(property)
        return false if property.nil? || !property.is_property?

        if property.is_owned?
            puts "CAN'T BUY #{property.name} (already owned by #{property.owner.name})"
            return false
        elsif @money >= property.price
            @money -= property.price
            property.owner = self
            puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
            return true
        else
            puts "NOT ENOUGH MONEY: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
            return false
        end
    end

    def pay_rent(property, board)
        if property.is_owned? && !property.is_owned_by?(self)
            rent = property.rent
            if property.is_rent_doubled?(board)
                rent *= 2
                puts "RENT DOUBLED: #{property.name} is part of a monopoly. Rent is doubled to $#{format('%.1f', rent)}."
            end
            @money -= rent
            property.owner.money += rent
            puts "PAY RENT: #{name} paid $#{format('%.1f', rent)}. #{property.owner.name}: $#{format('%.1f', property.owner.money)}. #{name}: $#{format('%.1f', @money)}."
        end
    end

    def is_bankrupt?
        @money < 0
    end
end