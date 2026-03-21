require_relative 'board'

class Property < Square
    attr_reader :name, :price, :colour
    attr_accessor :owner

    def initialize(name:, price:, colour:, owner: nil)
        super(name: name, type: "property")
        @price = price
        @colour = colour
        @owner = owner
    end
end

class Properties
    attr_reader :properties

    def initialize(properties: [])
        @properties = properties
    end

    def add_property(property)
        @properties << property
    end

    def has_property?(property)
      @properties.any? { |prop| prop.name == property.name }
    end
end
