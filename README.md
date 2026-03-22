# Technologies Used

- Language: Ruby on Rails (4.0.2)
- Test framework: RSpec (3.13)
  - rspec-core 3.13.6
  - rspec-expectations 3.13.5
  - rspec-mocks 3.13.8
  - rspec-support 3.13.7

# Folder Structure

To-be-put-in-later

# Important Setup

## Running program

1. [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/): Please remember to check the version of Ruby you're installing (version 4.0.2) to be similar to the version mentioned above.
2. Run program: `ruby src/main/main.rb`

## Test

1. Installing RSpec: `gem install rspec`
2. Double-check RSpec version by `gem exec rspec -v`
3. To run all tests

   1. Quick run: `gem exec rspec src/tests/`
   2. To check with tests passed: `gem exec rspec src/tests/ -f d` (--format documentation)
