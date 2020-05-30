module Calculated
  class PlayStyle
    attr_reader :attributes

    def initialize(data)
      @attributes = data['dataPoints'].to_h { |entry|
        [entry['name'], entry['average'].round(2)]
      }
    end

    def attribute(name)
      return @attributes.fetch(name.to_s)
    end

    def method_missing(name)
      return attribute(name)
    end
  end
end
