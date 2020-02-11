# frozen_string_literal: true

require_relative 'boot'

# Require the gems listed in Gemfile.
Bundler.require

module CryptoLibertarian
  module ReportIP
    IPV4_RE = /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/.freeze

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
