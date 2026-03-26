require_relative '../board'
require_relative 'square'
class Property < Square
  attr_reader :name, :colour, :price
  attr_accessor :owner, :rent, :is_rent_doubled

  def initialize(name:, price:, colour:, rent: (price.to_f / 2).round(1), owner: nil)
    raise ArgumentError, "price can't be nil" if price.nil?
    raise ArgumentError, "colour can't be nil" if colour.nil?

    super(name: name)
    @price = price
    @rent = rent.to_f.round(1)
    @colour = colour
    @owner = owner
    @is_rent_doubled = false
  end

  def is_owned?
    !@owner.nil?
  end

  def is_owned_by?(player)
    @owner == player
  end

  def on_land(current_player, board)
    return if is_owned_by?(current_player)
    if !is_owned?
      if current_player.money >= @price
        current_player.pay(@price, true)
        @owner = current_player
        board.update_rent_for_monopoly(current_player, @colour)
        puts "BUY: #{current_player.name} bought #{name} for $#{@price}."
      end
    else
      amount_paid = current_player.pay(@rent, true)
      @owner.receive(amount_paid, source: :rent)
    end
  end
end
