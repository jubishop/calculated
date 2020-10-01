require 'http'

require 'core'
require 'datacache'
require 'duration'
require 'rlranks'

require_relative 'exceptions'
require_relative 'play_style'

module Calculated
  class API
    @@player_cache = DataCache.new(1.hour)
    def self.player(id)
      return @@player_cache.fetch(id) { request("api/player/#{id}") }
    end

    def self.ranks(id, account = id)
      rank_list = request("api/player/#{account}/ranks")

      ranks = {}
      rank_list.each_pair { |playlist, info|
        rank = info.fetch('rank')
        mmr = info.fetch('rating')
        if rank.positive? && RANK_MAP.key?(playlist.to_sym)
          ranks[RANK_MAP.fetch(playlist.to_sym)] = [rank - 1, mmr]
        end
      }
      raise Error if ranks.empty?

      return RLRanks.new(id, account, **ranks)
    end

    @@play_style_cache = DataCache.new(10.minutes)
    def self.play_style(id)
      return @@play_style_cache.fetch(id) {
        PlayStyle.new(request("api/player/#{id}/play_style/all"))
      }
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
        response = HTTP.get(uri)
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
