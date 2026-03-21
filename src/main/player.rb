class Player
    attr_reader :name, :position, :money, :properties

    def initialize(name:, position: 0, money: 16)
        @name = name
        @position = position
        @money = money
    end
    
    def move(steps, board)
        @position = (@position + steps) % board.length
    end
end