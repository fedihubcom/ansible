# frozen_string_literal: true

require_relative 'boot'

# Require the gems listed in Gemfile.
Bundler.require

module CryptoLibertarian
  module ReportIP
    IPV4_RE = /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/.freeze
    IPV6_RE = /\A(((?=.*(::))(?!.*\3.+\3))\3?|[\dA-F]{1,4}:)([\dA-F]{1,4}(\3|:\b)|\2){5}(([\dA-F]{1,4}(\3|:\b|$)|\2){2}|(((2[0-4]|1\d|[1-9])?\d|25[0-5])\.?\b){4})\z/i.freeze

    class Application < Sinatra::Application
      get '/' do
        redis = Redis.new url: ENV['REDIS_URL']

        json redis.hgetall('ips')
      end

      post '/:domain/:secret' do
        redis = Redis.new url: ENV['REDIS_URL']

        domain = params[:domain].to_s.strip
        got_secret = params[:secret].to_s.strip

        expected_secret = redis.hget('secrets', domain).to_s.strip

        if got_secret != expected_secret || expected_secret.empty?
          halt 401, 'Unauthorized'
        end

        redis.hset 'ips', domain, request.ip

        json ip: request.ip
      end
    end
  end
end
