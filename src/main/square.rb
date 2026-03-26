class Square
  attr_reader :name

  def initialize(name:)
    raise ArgumentError, "name can't be nil" if name.nil?

    @name = name
  end
  protected :initialize

  def on_land(player, board)
    # Default
  end
end
