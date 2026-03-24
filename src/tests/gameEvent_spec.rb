require 'rspec/autorun'
require_relative '../main/game_event'
require_relative '../main/player'

describe 'GameEvent' do
  describe '#game_over_announcement' do
    board = Board.new
    board.add_square(Square.new(name: 'Go', type: 'go'))

    it 'prints the winner, players last position and net worth' do
      player1 = Player.new(name: 'Bob', money: 100)
      player2 = Player.new(name: 'Alice', money: 150)
      players = [player1, player2]

      game_event = GameEvent.new
      expect { game_event.game_over_announcement(players, board) }.to output(/WINNER: Alice with \$150/).to_stdout

      expect { game_event.game_over_announcement(players, board) }.to output(/Bob is on square 0: Go/).to_stdout
      expect { game_event.game_over_announcement(players, board) }.to output(/Alice is on square 0: Go/).to_stdout

      expect { game_event.game_over_announcement(players, board) }.to output(/Bob has \$100/).to_stdout
      expect { game_event.game_over_announcement(players, board) }.to output(/Alice has \$150/).to_stdout
    end

    it 'raises error if players is not a list with more than one player' do
      game_event = GameEvent.new
      expect { game_event.game_over_announcement([], board) }.to raise_error(ArgumentError)
      expect { game_event.game_over_announcement([Player.new(name: 'Bob')], board) }.to raise_error(ArgumentError)
    end
  end
end
