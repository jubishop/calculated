module Calculated
  class PlayStyle
    include Enumerable

    attr_reader :attributes

    def initialize(data)
      @attributes = data['dataPoints'].to_h { |entry|
        [entry['name'], entry['average']]
      }
    end

    def attribute(name)
      return @attributes.fetch(name.to_s)
    end

    def method_missing(name)
      return attribute(name)
    end

    def each
      attributes.each { |attribute| yield attribute }
    end
  end
end
