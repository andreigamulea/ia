require 'binance-ruby'

Binance::Api::Configuration.api_key = Rails.application.credentials.dig(:binance, :api_key)
Binance::Api::Configuration.secret_key = Rails.application.credentials.dig(:binance, :secret_key)