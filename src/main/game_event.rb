class GameEvent
  def print_winner(players)
    winner = players.max_by(&:money)
    puts "WINNER: #{winner.name} with $#{winner.money}"
    return winner
  end

  def players_last_position(players)
    players.each do |player|
      puts "#{player.name} is on square #{player.position}"
    end
  end

  def players_net_worth(players)
    players.each do |player|
      puts "#{player.name} has $#{player.money}"
    end
  end

  def game_over_announcement(players)
    raise ArgumentError, "players must be a list with more than one player" if players.length <= 1 # TODO: Check different type of errors
    
    print_winner(players)
    players_last_position(players)
    players_net_worth(players)
  end
end