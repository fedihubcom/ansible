# frozen_string_literal: true

require_relative 'boot'

# Require the gems listed in Gemfile.
Bundler.require

module ReportIP
  class Application < Sinatra::Application
    get '/' do
      'Hello, World!'
    end
  end
end
