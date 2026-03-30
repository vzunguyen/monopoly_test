# Folder Structure

| Path                               | Type      | Purpose                                                                   |
|------------------------------------|-----------|---------------------------------------------------------------------------|
| `Gemfile`                          | File      | Declares Ruby dependencies used by the project (RSpec, RuboCop).          |
| `README.md`                        | File      | Project documentation, setup instructions, and design notes.              |
| `rules/README.md`                  | File      | Challenge README with project requirements and constraints.               |
| `src/data/`                        | Directory | Input JSON files for board layout, players, and predefined dice rolls.    |
| `src/main/main.rb`                 | File      | Entry point that loads data, initializes players, and runs the game loop. |
| `src/main/board.rb`                | File      | `Board` class: square collection, monopoly checks, and rent updates.      |
| `src/main/player.rb`               | File      | `Player` class: movement, pay/receive flows, and bankruptcy state.        |
| `src/main/game_manager.rb`         | File      | Turn orchestration, movement flow, landing actions, and game end checks.  |
| `src/main/data_loader.rb`          | File      | JSON loader that builds board, players, and dice objects.                 |
| `src/main/cli_parser.rb`           | File      | Command-line argument parsing and validation.                             |
| `src/main/game_logger.rb`          | File      | Logging helpers for turn/game output.                                     |
| `src/main/dice/dice.rb`            | File      | Base dice interface/behavior.                                             |
| `src/main/dice/predefined_dice.rb` | File      | Dice implementation backed by predefined roll data.                       |
| `src/main/square/square.rb`        | File      | Base `Square` abstraction shared by board squares.                        |
| `src/main/square/go.rb`            | File      | `Go` square behavior.                                                     |
| `src/main/square/property.rb`      | File      | `Property` square: ownership, rent, and on-land behavior.                 |
| `src/tests/`                       | Directory | RSpec test suite for main game classes and flows.                         |
| `src/tests/test_data/`             | Directory | JSON fixtures used by loader and validation specs.                        |
| `vendor/`                          | Directory | Project-local bundled gems installed via Bundler.                         |

# Project Scope

- **Project Name:** Monopoly
- **Project Description:** A simple implementation of the Monopoly game.
- **Deadline:** 27th March 2026
- **Goal:** To create a simple simulation of the Monopoly game.

# Design Assumptions and Constraints

1. Player will not buy property when a player does not have enough money.
2. Players only go bankrupt when their money go under 0.
3. Rent price is different to property price: For this, I decided that rent price should be 50% property price as any prices under will make the rent too low for bankruptcy event to happen.
4. Dice rolls are not randomized, and only 1-6 roll values are possible.
5. If a player is going bankrupt, give the owner the remaining money of the player, and the player will have 0 money left.
6. GO will always be at the start of the board.

# How to run this application?
1. [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) (I'm using rbenv to manage Ruby versions)
2. I'm using `bundle` to manage gems in [Gemfile](Gemfile): `bundle install`
- RSpec: For test framework
- Rubocop: For code linting and formatting
3. To run the application:
- `bundle exec ruby src/main/main.rb -b [board_file_path] -d [dice_file_path] -p [player_file_path]`
- To get help, have more information about the command line arguments: `bundle exec ruby src/main/main.rb -h`
4. To run the tests:
- `bundle exec rspec src/tests/`
- `bundle exec rspec src/tests/ -f d` (--format documentation)
- `bundle exec rspec src/tests/ -f f` (--format failure)

*Additional: If you want to fix linting errors, use `bundle exec rubocop -a`*

# Notable Changes/Incidents

## Monopoly check: If player owns all properties of same colour

Several changes were made to this feature of the project, I will list them out according to when the change was made.
1. First, I considered to check monopoly whenever a player landed on a property. However, I found that this approach is not optimal as it will check for monopoly for all properties in the monopoly.
2. Then, I decided to check monopoly only when player buys property. However, I found that this approach will cause data integrity issues as we might miss out on the case where a player already has a monopoly and buy another property of the same colour.
3. Finally, after some reconsideration, I decided to have on land method in Property class that will trigger player behaviours happening when landing on the square. If a player is buying property, then I check for monopoly and update the price of the property. I believe this approach will allow if there is any other new behaviour happening on landing the square, I can just add it to the property class.

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

## Implementing GO Square
**What did I do at first?:** I decided to keep GO square as the base class Square as I believe with my implementation, there was no behaviour for Go Square.

**What I did next?:** I decided to create a new class GO Square that inherits from Square as it helps to keep the code clean and more extensible.

## Data Loader and Game Manager
- I decided to create a new class GameManager that will coordinate the game flow and manage the game state. I believe if there is any changes or adding in more specific game logic, I can build necessary objects and update the game manager without having to change the main file.
- I also decided to create a new class DataLoader that will load the data from JSON files then creating and building Game objects: Board, Players, and Dice Rolls. I believe this will help to keep the code clean and more extensible as if there is any changes, we can just change the data loader and the game manager will be updated accordingly.

## Command Line Arguments
- As the game of the previous state was static, I believe having any form of user input will make the game more dynamic and extensible. Therefore, I decided to use command line arguments to allow users to input the file paths for board, dice rolls, and players. This will open up the possibility of having more dynamic game states, and will allow users to play the game with different board layouts and different player setups.