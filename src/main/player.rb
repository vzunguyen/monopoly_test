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

  def pay(amount, mandatory)
    amount_to_pay = [amount, @money].min
    if @money >= amount
      @money -= amount_to_pay
    elsif mandatory
      @money -= amount_to_pay
      @is_bankrupt = true
    end
    puts "PAY: #{name} paid $#{amount}. REMAINING MONEY: $#{@money}"
    amount_to_pay
  end

  def receive(amount, source: :generic)
    return if amount.nil? || amount <= 0

    @money += amount
    if source == :pass_go
      puts "GAIN MONEY AT GO: #{name} passed 'Go', gained $#{amount}. TOTAL MONEY: $#{@money}"
      return
    end

    puts "RECEIVE: #{name} received $#{amount}. TOTAL MONEY: $#{@money}"
  end
end
