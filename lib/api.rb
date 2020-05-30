require 'http'

require 'rlranks'

require_relative 'exceptions'

module Calculated
  class API
    def self.player(id)
      return request("api/player/#{id}")
    end

    def self.ranks(id, account = id)
      rank_list = request("api/player/#{account}/ranks")

      ranks = {}
      rank_list.each_pair { |playlist, info|
        rank = info.fetch('rank')
        ranks[RANK_MAP.fetch(playlist.to_sym)] = rank - 1 if rank.positive?
      }
      raise Error if ranks.empty?

      return Ranks.new(id, account, **ranks)
    end

    ##### PRIVATE #####

    RANK_MAP = {
      doubles: :doubles,
      dropshot: :dropshot,
      duel: :duel,
      hoops: :hoops,
      rumble: :rumble,
      snowday: :snow_day,
      solo: :solo_standard,
      standard: :standard
    }.freeze
    private_constant :RANK_MAP

    def self.request(path)
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
    private_class_method :request
  end
end
