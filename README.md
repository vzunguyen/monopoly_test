# Technologies Used

- Language: Ruby on Rails (4.0.2)
- Test framework: RSpec (3.13)
  - rspec-core 3.13.6
  - rspec-expectations 3.13.5
  - rspec-mocks 3.13.8
  - rspec-support 3.13.7

# Folder Structure

To-be-put-in-later

# Design Assumptions

1. Player will not buy property when player do not have enough money.
2. Player only go bankrupt when their money go under 0.
3. Rent price (?)

# How to run this application?

## Running program

1. [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/): Please remember to check the version of Ruby you're installing (version 4.0.2) to be similar to the version mentioned above.
2. Run program: `ruby src/main/main.rb`

## Test

1. Installing RSpec: `gem install rspec`
2. Double-check RSpec version by `gem exec rspec -v`
3. To run all tests
   1. Quick run: `gem exec rspec src/tests/`
   2. To check with tests passed: `gem exec rspec src/tests/ -f d` (--format documentation)
   3. `gem exec rspec src/tests/ -f f` (--format failure)

# Git Log History

To-be-added

# Notable Changes

## Monopoly check: If player owns all properties of same colour

Considered having Board checking monopoly whenever a Player land on a property. For example:

````
**PSEUDOCODE**

for each roll in dice_file
  player.move
  player.buy_property
  board.check_for_monopoly # Check and update price here
  player.pay_rent
end
````

**Problem:** Poor Time Complexity

**Solution:** Check and update price when the player (owner) buy_property. Time complexity now O(2n) when player decides to buy_property.

````
**PSEUDOCODE**

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
