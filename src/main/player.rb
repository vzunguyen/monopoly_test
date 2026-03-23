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
            puts "CAN'T BUY #{property.name} (already owned by #{property.owner.name})"
            return false
        elsif @money >= property.price
            @money -= property.price
            property.owner = self
            # TODO: Check for monopoly and update rent if necessary
            board.update_rent_for_monopoly(self, property.colour)
            puts "BUY: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
            return true
        else
            puts "NOT ENOUGH MONEY: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
            return false
        end
    end

    def pay_rent(property, board)
        if property.is_owned? && !property.is_owned_by?(self)
            if property.is_rent_doubled?(board)
                property.rent *= 2
                puts "RENT DOUBLED: #{property.name} rent is doubled to $#{property.rent} due to monopoly."
            end
            @money -= property.rent
            property.owner.money += property.rent
            puts "PAY RENT: #{name} paid $#{property.rent}. #{property.owner.name}: $#{property.owner.money}. #{name}: $#{@money}."
        end
    end

    def is_bankrupt?
        @money < 0
    end
end