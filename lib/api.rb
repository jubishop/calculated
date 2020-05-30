require 'http'

module Calculated
  class API
    def self.player(id)
      return request("api/player/#{id}")
    end

    def request(path)
      uri = HTTP::URI.new(
        scheme: 'https',
        host: 'calculated.gg',
        path: path)

      begin
        response = HTTP.auth(@token).get(uri)
        raise Calculated::Error, uri unless response.status.success?
        data = response.parse
      rescue HTTP::Error
        raise Calculated::Error, uri
      end

      return data
    end
  end
end