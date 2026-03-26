require 'rspec/autorun'
require_relative '../main/square/property'
require_relative '../main/board'
require_relative '../main/player'

describe 'Property' do
  describe '#initialize' do
    let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue') }

    it 'initializes with the correct name, price, and colour' do
      expect(owned_property).to have_attributes(name: 'Boardwalk', price: 4, colour: 'dark blue', owner: nil)
    end

    it 'returns error if initialized with no price or colour' do
      expect { Property.new(name: 'ErrorProperty') }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', price: 4) }.to raise_error(ArgumentError)
      expect { Property.new(name: 'ErrorProperty', colour: 'blue') }.to raise_error(ArgumentError)
    end

    it 'returns error if initialized with no name or name is nil' do
      expect { Property.new(price: 400, colour: 'blue') }.to raise_error(ArgumentError)
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
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue', owner: owner)
      expect(property.is_owned_by?(owner)).to eq(true)
    end

    it 'returns false if property is not owned by any player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue')
      expect(property.is_owned_by?(bob)).to eq(false)
    end

    it 'returns false if property is owned by another player' do
      property = Property.new(name: 'Boardwalk', price: 4, colour: 'dark blue', owner: alice)
      expect(property.is_owned_by?(bob)).to eq(false)
    end
  end

  describe '#on_land' do
    context 'when handling buying property' do
      let(:bob) { Player.new(name: 'Bob') }
      let(:owner) { Player.new(name: 'Alice') }
      let(:property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue') }
      let(:owned_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue', owner: owner) }
      let(:board) { Board.new(squares: [property, owned_property]) }

      it 'player buys property if property not owned' do
        before_payment = bob.money
        property.on_land(bob, board)
        expect(bob.money).to eq(before_payment - property.price)
        expect(property.owner).to eq(bob)
      end

      it 'player does not buy property if property already owned' do
        owned_property.on_land(bob, board)
        expect(owned_property.owner).not_to eq(bob)
      end

      it 'player does not buy property if player does not have enough money' do
        bob.money = 2
        property.on_land(bob, board)
        expect(property.owner).to be_nil
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
        previous_property_rent = property.rent
        previous_owned_property_rent = owned_property.rent
        property.on_land(owner, board)
        expect(board.check_for_monopoly(owner, 'blue')).to eq(true)

        expect(property.owner).to eq(owner)
        expect(property.rent).to eq(previous_property_rent * 2)

        expect(owned_property.owner).to eq(owner)
        expect(owned_property.rent).to eq(previous_owned_property_rent * 2)
      end

      it 'calls pay and updates property owner if property not owned and player has enough money' do
        allow(bob).to receive(:pay).and_call_original
        property.on_land(bob, board)
        expect(bob).to have_received(:pay).with(property.price, true)
        expect(property.owner).to eq(bob)
      end
    end
    context 'when handling renting payment' do
      let(:bob) { Player.new(name: 'Bob') }
      let(:alice) { Player.new(name: 'Alice') }
      let(:owned_property) { Property.new(name: 'Boardwalk', price: 4, colour: 'blue', owner: alice) }
      let(:park_property) { Property.new(name: 'Park Place', price: 4, colour: 'blue') }
      let(:board) { Board.new(squares: [owned_property, park_property]) }

      it 'calls pay, pays rent, and call receive if landed on owned property' do
        allow(bob).to receive(:pay).and_call_original
        allow(alice).to receive(:receive).and_call_original
        owned_property.on_land(bob, board)
        expect(bob).to have_received(:pay).with(owned_property.rent, true)
        expect(alice).to have_received(:receive).with(owned_property.rent, source: :rent)
      end
    end
  end
end
