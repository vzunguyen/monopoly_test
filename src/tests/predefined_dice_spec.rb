# frozen_string_literal: true

require 'rspec/autorun'
require_relative '../main/dice/predefined_dice'

describe 'PredefinedDice' do
  it 'rolls the correct dice' do
    dice = PredefinedDice.new(rolls_data: [1, 2, 3, 4, 5, 6])
    expect(dice.roll).to eq(1)
    expect(dice.roll).to eq(2)
    expect(dice.roll).to eq(3)
    expect(dice.roll).to eq(4)
    expect(dice.roll).to eq(5)
    expect(dice.roll).to eq(6)
  end

  it 'raises error if rolls_data is empty' do
    expect { PredefinedDice.new(rolls_data: []) }.to raise_error(ArgumentError, /ERROR: Roll data is needed/)
  end

  it 'raises error if rolls_data is nil' do
    expect { PredefinedDice.new(rolls_data: nil) }.to raise_error(ArgumentError, /ERROR: Roll data is needed/)
  end

  describe '#roll' do
    it 'raises error if roll number is more than 6' do
      dice = PredefinedDice.new(rolls_data: [7])
      expect { dice.roll }.to raise_error(RuntimeError, /ERROR: Roll need to be in range 1-6/)
    end

    it 'returns the correct roll number order' do
      dice = PredefinedDice.new(rolls_data: [3, 4, 5])
      expect(dice.roll).to eq(3)
      expect(dice.roll).to eq(4)
      expect(dice.roll).to eq(5)
    end
  end

  describe '#is_end?' do
    let(:dice) { PredefinedDice.new(rolls_data: [1, 2, 3]) }
    it 'returns true if rolled through all numbers of the dice data' do
      expect(dice.roll).to eq(1)
      expect(dice.roll).to eq(2)
      expect(dice.roll).to eq(3)

      expect(dice.is_end?).to eq(true)
    end

    it 'returns false if not rolled through all numbers of the dice data' do
      expect(dice.roll).to eq(1)
      expect(dice.roll).to eq(2)

      expect(dice.is_end?).to eq(false)
      end
  end
end
