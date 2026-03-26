# frozen_string_literal: true

class PredefinedDice < Dice
  def initialize(rolls_data:)
    super
    @rolls_data = rolls_data
  end
  def roll
    @rolls_data.shift
  end

  def is_last_roll?
    @rolls_data.empty?
  end
end
