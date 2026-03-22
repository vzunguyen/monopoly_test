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
        if property.price > @money
            puts "ERROR: #{name} does not have enough money to buy #{property.name}"
            return false
        else
            @money -= property.price
            property.owner = self
            puts "DEBUG: #{name} bought #{property.name} for $#{property.price}. Remaining money: $#{@money}"
            return true
        end
    end
end