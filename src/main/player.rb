class Player
    attr_reader :name, :position, :money

    def initialize(name:, position: 0, money: 16)
        @name = name
        @position = position
        @money = money
    end
    
    def move(steps, board)
        @position = (@position + steps) % board.length
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
end