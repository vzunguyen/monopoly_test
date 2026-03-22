class Player
    attr_reader :name, :position, :money

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
        if property.is_owned?
            puts "DEBUG: #{property.name} is already owned by #{property.owner.name}"
            return false
        elsif @money >= property.price
            @money -= property.price
            property.owner = self
            puts "DEBUG: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
            return true
        else
            puts "DEBUG: #{name} does not have enough money to buy #{property.name}. Required: $#{property.price}, Available: $#{@money}"
            return false
        end
    end

    def pay_rent(property)
        if property.is_owned? && !property.is_owned_by?(self)
            rent = property.price / 10
            @money -= rent
            property.owner.money += rent
            puts "DEBUG: #{name} paid $#{rent} in rent to #{property.owner.name} for landing on #{property.name}. Remaining money: $#{@money}"
        end
    end
end