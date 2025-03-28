require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ia
  class Application < Rails::Application
    #config.i18n.default_locale = :ro

    # Initialize configuration defaults for originally generated Rails version.
    config.eager_load_paths << Rails.root.join('app', 'controllers', 'concerns')
    config.autoload_paths += Dir["#{config.root}/app/controllers/**/"]

    config.load_defaults 7.0
    #config.autoload_paths += %W(#{config.root}/app/controllers/concerns)
    config.session_store :cookie_store, key: '_your_app_session'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'https://ayushcell.ro', 'http://localhost:3000'
        resource '/priority_flag',
          headers: :any,
          methods: [:get],
          expose: ['Access-Control-Allow-Origin'],
          credentials: true
      end
    end
    
    
    

  end
end
