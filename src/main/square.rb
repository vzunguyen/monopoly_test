class Square
  attr_reader :name
  def initialize(name:)
    raise ArgumentError, "name can't be nil" if name.nil?
    @name = name
  end
  protected :initialize

  # TODO: Have a method for landing square - default nothing - if type property -> behaviours.
  def on_land(player, board)
    # Default
  end
end