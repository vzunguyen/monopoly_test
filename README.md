# Folder Structure

| Path                     | Type      | Purpose                                                                                                       |
|--------------------------|-----------|---------------------------------------------------------------------------------------------------------------|
| `Gemfile`                | File      | Declares Ruby dependencies used by the project (RSpec, RuboCop, etc.).                                        |
| `README.md`              | File      | Project documentation, setup instructions, and design notes.                                                  |
| `rules/README.md`        | File      | The given README file that explains requirements of the project.                                              |
| `src/data/`              | Directory | Input JSON files used by the game (board layout and dice rolls).                                              |
| `src/main/main.rb`       | File      | Entry point for the game; initializes players, loads board and dice data, and runs game simulation.           |
| `src/main/player.rb`     | File      | Player class definition and related methods (move, buy property, pay rent, bankruptcy check).                 |
| `src/main/board.rb`      | File      | Board and Square class definitions; manages board squares and monopoly rent calculations.                     |
| `src/main/property.rb`   | File      | Property class definition (extends Square); manages property ownership, rent, and monopoly detection.         |
| `src/main/game_event.rb` | File      | GameEvent class for game state reporting (winner announcement, player positions, how much players have left). |
| `src/tests/`             | Directory | RSpec test suite for core classes and behaviors.                                                              |

# Design Assumptions

1. Player will not buy property when player does not have enough money.
2. Players only go bankrupt when their money go under 0.
3. Rent price is different to property price: For this, I decided that rent price should be 50% property price as any prices under will make the rent too low for bankruptcy event to happen.

# How to run this application?
1. [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) (I'm using rbenv to manage Ruby versions)
2. As I'm using Homebrew Ruby, I'm using `bundle` to manage gems in [Gemfile](Gemfile): `bundle install`
- RSpec: For test framework
- Rubocop: For code linting and formatting
3. To run the application, use `bundle exec ruby src/main/main.rb` in terminal.
4. To run the tests:
- `bundle exec rspec src/tests/`
- `bundle exec rspec src/tests/ -f d` (--format documentation)
- `bundle exec rspec src/tests/ -f f` (--format failure)

*Additional: If you want to fix linting errors, use `bundle exec rubocop -a`*

# Git Log History

To-be-added

# Notable Changes/Incidents

## Monopoly check: If player owns all properties of same colour

Several changes were made to this feature of the project, I will list them out according to when the change was made.

### 1. Having Board checking monopoly whenever a Player land on a property

Considered having Board checking monopoly whenever a Player land on a property. For example:

````
for each roll in dice_file
  player.move
  player.buy_property
  board.check_for_monopoly # Check and update price here
  player.pay_rent
end
````

**Problem:** Poor Time Complexity

### 2. Check monopoly when player buy property/pay rent, but only check the property that is bought

**Reasoning for change:** Time complexity now O(2n) when player decides to buy_property.
**Notes:** I did try to check monopoly when player pay rent with reasoning that if player only needs to pay double rent in the pay_rent method, no need to save the property price rent. However, due to later design changes with consideration to data integrity, I decided to check monopoly only when the player buys property.

````
class Player
  def buy_property
    # Check other conditions ...
    if enough money
      player pay for property
      property check is rent doubled -> update price
    end
  end
end

for each roll in dice_file
  player.move
  player.buy_property
  player.pay_rent
end
````

※ **Problem:** 
1. Data Integrity: If we only check the property that is bought, we might miss out on the case where player already has a monopoly and buy another property of the same colour.

### 3. Update rent price for all properties in the monopoly when player buy property

※ **Reasoning for change:** Data integrity is now maintained as we check for all properties of the same colour when player buy property. Time complexity is O(2n) when player decides to buy_property.
````
class Player
  def buy_property
    # Check other conditions ...
    if enough money
      player pay for property
      board.update_price_for_monopoly # Update price for all properties in the monopoly
    end
  end
end
````

## Rent price: From the same value to price to creating a new attribute

Before: 
```
class Property
    attr_accessor :price
end

if player.buy_property: player.money -= property.price
if player.pay_rent: player.money -= property.price
```

※ **Problem:**
1. Data Consistency: If we change the price of the property, the rent price will also change.
2. Introducing Bugs: If we change the price of the property for rent, the original property price will also be changed. Despite situations such as buying the property again is not possible in this scenario, this design will make it hard to expand the game.

