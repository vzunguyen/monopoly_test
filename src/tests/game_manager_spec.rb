# frozen_string_literal: true

require 'rspec'
require_relative '../main/game_manager'
require_relative '../main/board'
require_relative '../main/square/go'
require_relative '../main/square/property'
require_relative '../main/player'
require_relative '../main/game_logger'

describe 'Game Manager' do
  describe '#initialize' do
    let(:board) { Board.new }
    let(:player) { Player.new(name: 'Bob') }
    let(:dice) { PredefinedDice.new(rolls_data: [1, 2, 3]) }

    before do
      board.add_square(Go.new)
      board.add_square(Property.new(name: 'Boardwalk', price: 4, colour: 'blue'))
      board.add_square(Property.new(name: 'Park Place', price: 4, colour: 'blue'))
    end
    it 'initializes with board, players and dice' do
      game_manager = GameManager.new(board, [player], dice)
      expect(game_manager.board).to eq(board)
      expect(game_manager.players).to eq([player])
      expect(game_manager.dice).to eq(dice)
    end

    it 'raises ArgumentError if board data is nil' do
      expect { GameManager.new(nil, [player], dice) }.to raise_error(ArgumentError, /ERROR: Board data is needed/)
    end

    it 'raises ArgumentError if players data is nil' do
      expect {
        GameManager.new(board, nil, dice)
      }.to raise_error(ArgumentError, /ERROR: Players data is needed/)
    end

    it 'raises ArgumentError if dice data is nil' do
      expect {
        GameManager.new(board, [player], nil)
      }.to raise_error(ArgumentError, /ERROR: Dice data is needed/)
    end

    it 'raises ArgumentError if players data is empty' do
      expect {
        GameManager.new(board, [], dice)
      }.to raise_error(ArgumentError, /ERROR: Players data is needed/)
    end
  end
  def on_land(current_player, board)
    return if is_owned_by?(current_player)

    if !is_owned? && current_player.money >= @price
      current_player.pay(@price, true)
      @owner = current_player
      board.update_rent_for_monopoly(current_player, @colour)
      puts "BUY: #{current_player.name} bought #{name} for $#{@price}."
    elsif is_owned?
      amount_paid = current_player.pay(@rent, true)
      @owner.receive(amount_paid, source: :rent)
    end

    puts "REMAINING MONEY: $#{current_player.money}"
  end
  describe '#game_is_over?' do
    let(:board) { Board.new }
    let(:dice) { PredefinedDice.new(rolls_data: [1, 2, 3]) }
    let(:player) { Player.new(name: 'Bob') }
    let(:game_manager) { GameManager.new(board, [player], dice) }

    before do
      board.add_square(Go.new)
      board.add_square(Property.new(name: 'Boardwalk', price: 4, colour: 'blue'))
      board.add_square(Property.new(name: 'Park Place', price: 4, colour: 'blue'))
    end

    it 'returns true if player is bankrupt' do
      allow(player).to receive(:is_bankrupt).and_return(true)
      expect(game_manager.game_is_over(player, dice)).to eq(true)
    end

    it 'returns true if dice is end' do
      allow(dice).to receive(:is_end?).and_return(true)
      expect(game_manager.game_is_over(player, dice)).to eq(true)
    end

    it 'returns false if player is not bankrupt and dice is not end' do
      expect(game_manager.game_is_over(player, dice)).to eq(false)
    end
  end
end
