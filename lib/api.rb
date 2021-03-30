require 'http'

require 'core'
require 'datacache'
require 'duration'
require 'rlranks'

require_relative 'exceptions'

module Calculated
  class API
    def self.player(id)
      return player_cache.fetch(id) { request("api/player/#{id}") }
    end

    def self.ranks(id, account = id)
      rank_list = request("api/player/#{account}/ranks")

      ranks = {}
      rank_list.each_pair { |playlist, info|
        rank = info.fetch('rank')
        mmr = info.fetch('rating')
        if rank.positive?
          ranks[RANK_MAP.fetch(playlist.to_sym)] = [rank - 1, mmr]
        end
      }
      raise Error if ranks.empty?

      return RLRanks.new(id, account, **ranks)
    end

    ##### PRIVATE #####

    RANK_MAP = {
      doubles: :doubles,
      dropshot: :dropshot,
      duel: :duel,
      hoops: :hoops,
      rumble: :rumble,
      snowday: :snow_day,
      standard: :standard,
      tournament: :tournament
    }.freeze
    private_constant :RANK_MAP

    @player_cache = DataCache.new(1.hour)
    class << self
      private

      attr_reader :player_cache

      def request(path)
        uri = HTTP::URI.new(
            scheme: 'https',
            host: 'calculated.gg',
            path: path)

        begin
          response = HTTP.get(uri)
          raise Calculated::Error, uri unless response.status.success?

          data = response.parse
        rescue HTTP::Error
          raise Calculated::Error, uri
        end

        return data
      end
    end
  end
end
