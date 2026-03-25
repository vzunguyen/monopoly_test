require 'rspec/autorun'
require_relative '../main/game_event'
require_relative '../main/player'
require_relative '../main/board'
require_relative '../main/go'
require_relative '../main/property'

describe 'GameEvent' do
  describe '#game_over_announcement' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob', money: 15) }
    let(:alice) { Player.new(name: 'Alice', money: 20) }
    let(:game_event) { GameEvent.new }

    before do
      board.add_square(Go.new)
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

  describe '#print_winner' do
    let(:game_event) { GameEvent.new }
    let(:alice) { Player.new(name: 'Alice', money: 20) }
    let(:bob) { Player.new(name: 'Bob', money: 15) }

    it 'prints and returns the winner' do
      expect(game_event.print_winner([alice, bob])).to eq(alice)
      expect { game_event.print_winner([alice, bob]) }.to output(/WINNER: Alice with \$20/).to_stdout
    end
  end

  describe '#players_last_position' do
    let(:game_event) { GameEvent.new }
    let(:board) { Board.new }
    let(:alice) { Player.new(name: 'Alice', money: 20) }
    let(:bob) { Player.new(name: 'Bob', money: 15) }
    let(:charlotte) { Player.new(name: 'Charlotte', money: 12) }
    let(:go) { Go.new }
    let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
    let(:park_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }

    before do
      board.add_square(go)
      board.add_square(property)
      board.add_square(park_property)
    end

    it 'prints each player position with square name' do
      players = [alice, bob]
      alice.move(1, board)

      expect { game_event.players_last_position(players, board) }.to output(
        /--- PLAYERS LAST POSITION ---\nAlice is on square 1: Boardwalk\nBob is on square 0: Go\n/
      ).to_stdout
    end

    it 'prints correct positions for three players in order' do
      players = [alice, bob, charlotte]
      alice.move(1, board)
      bob.move(2, board)

      expect { game_event.players_last_position(players, board) }.to output(
        /Alice is on square 1: Boardwalk\nBob is on square 2: Park Place\nCharlotte is on square 0: Go\n/
      ).to_stdout
    end
  end

  describe '#players_net_worth' do
    let(:game_event) { GameEvent.new }
    let(:alice) { Player.new(name: 'Alice', money: 20) }
    let(:bob) { Player.new(name: 'Bob', money: 15) }
    let(:charlotte) { Player.new(name: 'Charlotte', money: 12) }

    it 'prints each player net worth in order' do
      players = [alice, bob, charlotte]

      expect { game_event.players_net_worth(players) }.to output(
        /--- PLAYERS NET WORTH ---\nAlice has \$20\nBob has \$15\nCharlotte has \$12\n/
      ).to_stdout
    end

    it 'returns the same players collection' do
      players = [alice, bob]

      result = game_event.players_net_worth(players)

      expect(result).to eq(players)
    end
  end
end
