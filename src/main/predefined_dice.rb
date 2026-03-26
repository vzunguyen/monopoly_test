# frozen_string_literal: true

require_relative 'dice'
class PredefinedDice < Dice
  def initialize(rolls_data: [])
    raise ArgumentError, 'ERROR: Roll data is needed' if rolls_data.nil? || rolls_data.empty?

    @rolls_data = rolls_data
  end

  def roll
    current_roll = @rolls_data.shift
    raise 'ERROR: Roll need to be in range 1-6' unless (1..6).cover?(current_roll)

    current_roll
  end

  def is_end?
    @rolls_data.empty?
  end
end
