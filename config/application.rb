require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_storage.variant_processor = :mini_magick
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: true,
                       helper_specs: true,
                        routing_specs: false
      end

  end
end