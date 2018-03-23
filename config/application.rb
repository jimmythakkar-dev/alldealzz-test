require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fandy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = Settings.app_timezone
    # config.web_console.whitelisted_ips = '192.168.2.0/24'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
    config.action_mailer.asset_host = Settings.main_uri
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :delayed_job

    config.to_prepare do
		  Devise::Mailer.layout "mailer"
		end
    
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        
        resource '/api/*', 
          headers: ['Origin', 'X-Requested-With', 'Authorization', 'Content-Type', 'Accept'], 
          methods: [:get, :post, :patch, :options]
      end
    end
  end
end
