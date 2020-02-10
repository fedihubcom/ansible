# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

run ->(env) { [200, { 'Content-Type' => 'text/plain' }, ['Hello, World!']] }
