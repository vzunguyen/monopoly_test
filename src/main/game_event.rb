class GameEvent
  def print_winner(players)
    winner = players.max_by(&:money)
    puts "WINNER: #{winner.name} with $#{winner.money}"
    winner
  end

  def players_last_position(players, board)
    puts '--- PLAYERS LAST POSITION ---'
    players.each do |player|
      square = board[player.position]
      puts "#{player.name} is on square #{player.position}: #{square.name}"
    end
  end

  def players_net_worth(players)
    puts '--- PLAYERS NET WORTH ---'
    players.each do |player|
      puts "#{player.name} has $#{player.money}"
    end
  end

  def game_over_announcement(players, board)
    raise ArgumentError, 'players must be a list with more than one player' if players.length <= 1

    puts "\n--- GAME OVER ---"
    print_winner(players)
    players_last_position(players, board) # Assuming all players are on the same square at game over
    players_net_worth(players)
  end
end
