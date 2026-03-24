require 'rspec/autorun'
require_relative '../main/game_event'
require_relative '../main/player'

describe 'GameEvent' do
  describe '#game_over_announcement' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob', money: 15) }
    let(:alice) { Player.new(name: 'Alice', money: 20) }
    let(:game_event) { GameEvent.new }

    before do
      board.add_square(Square.new(name: 'Go', type: 'go'))
    end

    it 'prints the winner, players last position and net worth' do
      players = [bob, alice]

      expect { game_event.game_over_announcement(players, board) }.to output(/WINNER: Alice with \$20/).to_stdout

      expect { game_event.game_over_announcement(players, board) }.to output(/Bob is on square 0: Go/).to_stdout
      expect { game_event.game_over_announcement(players, board) }.to output(/Alice is on square 0: Go/).to_stdout

      expect { game_event.game_over_announcement(players, board) }.to output(/Bob has \$15/).to_stdout
      expect { game_event.game_over_announcement(players, board) }.to output(/Alice has \$20/).to_stdout
    end

    it 'raises error if players is not a list with more than one player' do
      expect { game_event.game_over_announcement([], board) }.to raise_error(ArgumentError)
      expect { game_event.game_over_announcement([bob], board) }.to raise_error(ArgumentError)
    end
  end
end
