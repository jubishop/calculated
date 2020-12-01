require 'duration'

module Calculated
  class PlayStyle
    include Enumerable

    def initialize(data)
      @attributes = data['dataPoints'].to_h { |entry|
        avg = if entry['name'].start_with?('time')
                entry['average'].seconds
              else
                entry['average'].round(3)
              end
        [entry['name'], avg]
      }
      puts @attributes
    end

    def attribute(name)
      return @attributes.fetch(name.to_s)
    end

    def each(&block)
      @attributes.each(&block)
    end
  end
end
