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

    def each(&block)
      attributes.each(&block)
    end
  end
end
