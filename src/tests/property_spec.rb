require 'rspec/autorun'
require_relative '../main/square/property'
require_relative '../main/board'
require_relative '../main/player'

describe 'Property' do
  describe '#initialize' do
    let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue') }

    it 'initializes with the correct name, price, and colour' do
      expect(property.name).to eq('Boardwalk')
      expect(property.price).to eq(4)
      expect(property.colour).to eq('dark blue')
      expect(property.owner).to eq(nil)
    end

    it 'returns error if initialized with no price or colour' do
      expect { Property.new(name: 'ErrorProperty') }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', price: 4) }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with no name' do
      expect { Property.new(price: 400, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil name' do
      expect { Property.new(name: nil, price: 400, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil price' do
      expect { Property.new(name: 'ErrorProperty', price: nil, colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with nil colour' do
      expect { Property.new(name: 'ErrorProperty', price: 400, colour: nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#is_owned?' do
    let(:board) { Board.new }

    it 'returns true if property is owned by any player' do
      owner = Player.new(name: 'Bob')
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      owner.buy_property(property)
      expect(property.owner).to eq(owner)

      expect(property.is_owned?).to eq(true)
    end

    it 'returns false if property is not owned by any player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(property.is_owned?).to eq(false)
    end
  end

  describe '#is_owned_by?' do
    let(:board) { Board.new }
    let(:bob) { Player.new(name: 'Bob') }
    let(:alice) { Player.new(name: 'Alice') }

    it 'returns true if property is owned by the player' do
      owner = Player.new(name: 'Bob')
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')

      owner.buy_property(property)
      expect(property.owner).to eq(owner)
    end

    it 'returns false if property is not owned by any player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(property.is_owned_by?(bob)).to eq(false)
    end

    it 'returns false if property is owned by another player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      alice.buy_property(property)

      expect(property.is_owned_by?(bob)).to eq(false)
    end
  end

  describe '#on_land' do
    context 'when handling buying property' do
      let(:board) { Board.new }
      let(:player) { Player.new(name: 'Bob') }
      let(:owner) { Player.new(name: 'Alice') }
      let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
      let(:owned_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }

      before do
        board.add_square(property)
        board.add_square(owned_property)
        owner.buy_property(owned_property)
      end

      it 'player buys property if property not owned' do
        property.on_land(player, board)
        expect(property.is_owned_by?(player)).to eq(true)
      end

      it 'player does not buy property if property already owned' do
        property.on_land(player, board)
        expect(owned_property.is_owned_by?(player)).to eq(false)
      end

      it 'player does not buy property if player does not have enough money' do
        player.money = 2
        property.on_land(player, board)
        expect(property.is_owned_by?(player)).to eq(false)
      end

      it 'not update rent when player does not own last blue property' do
        new_property = Property.new(name: 'New Blue Property', price: 4, colour: 'blue')
        board.add_square(new_property)
        new_property.on_land(owner, board)

        expect(board.check_for_monopoly(owner, 'blue')).to eq(false)
        expect(new_property.owner).to eq(owner)
        expect(new_property.rent).to eq(2.0)
      end

      it 'updates rent when player the last blue property' do
        property.on_land(owner, board)
        expect(board.check_for_monopoly(owner, 'blue')).to eq(true)

        expect(property.owner).to eq(owner)
        expect(property.rent).to eq(4.0)

        expect(owned_property.owner).to eq(owner)
        expect(owned_property.rent).to eq(4.0)
      end
    end
    context 'when handling renting payment' do
      let(:board) { Board.new }
      let(:bob) { Player.new(name: 'Bob') }
      let(:alice) { Player.new(name: 'Alice') }
      let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
      let(:park_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }

      before do
        board.add_square(property)
        alice.buy_property(property) # money: 12
      end

      it 'player pay correct amount of rent and owner receives correct amount of payment' do
        expect(alice.money).to eq(12)
        expect(bob.money).to eq(16)

        property.on_land(bob, board)

        expect(alice.money).to eq(14)
        expect(bob.money).to eq(14)
      end

      it 'player does not pay rent if property is owned by the player' do
        expect(alice.money).to eq(12)

        property.on_land(alice, board)

        expect(alice.money).to eq(12)
      end

      it 'player pays the rest of money if player does not have enough money' do
        expect(alice.money).to eq(12)

        bob.money = 1
        property.on_land(bob, board)

        expect(bob.money).to eq(0)
        expect(bob.is_bankrupt).to eq(true)
        expect(alice.money).to eq(13)
      end
    end
  end
end
