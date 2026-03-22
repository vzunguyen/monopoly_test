require_relative 'board'

class Property < Square
    attr_reader :name, :price, :colour
    attr_accessor :owner

    def initialize(name:, price:, colour:, owner: nil)
      raise ArgumentError, "price can't be nil" if price.nil?
      raise ArgumentError, "colour can't be nil" if colour.nil?
        super(name: name, type: "property")
        @price = price
        @colour = colour
        @owner = owner
    end

    def is_owned?
        !@owner.nil?
    end

    def is_owned_by?(player)
        @owner == player
    end
end

class Properties
    attr_reader :properties

    def initialize(properties: [])
        @properties = properties
    end

    def [](index)
        @properties[index]
    end

    def length
        @properties.length
    end

    def add_property(property)
        @properties << property
    end

    def has_property?(property)
      @properties.any? { |prop| prop.name == property.name }
    end
end
