# frozen_string_literal: true

require_relative 'boot'

# Require the gems listed in Gemfile.
Bundler.require

module ReportIP
  class Application < Sinatra::Application
    post '/:domain/:secret' do
      redis = Redis.new url: ENV['REDIS_URL']

      domain = params[:domain].to_s.strip
      got_secret = params[:secret].to_s.strip

      expected_secret = redis.hget('secrets', domain).to_s.strip

      if got_secret != expected_secret || expected_secret.empty?
        halt 401, 'Unauthorized'
      end

      redis.hset 'ips', domain, request.ip

      request.ip
    end
  end
end
