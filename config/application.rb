require_relative "boot"

require "rails/all"
require "graphiti"
require "graphiti/resource"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FoodsiCookbook
  class Application < Rails::Application
    # In order for Graphiti to generate links, you need to set the routes host.
    # When not explicitly set, via the HOST env var, this will fall back to
    # the rails server settings.
    # Rails::Server is not defined in console or rake tasks, so this will only
    # use those defaults when they are available.
    routes.default_url_options[:host] = ENV.fetch('HOST') do
      if defined?(Rails::Server)
        argv_options = Rails::Server::Options.new.parse!(ARGV)
        "http://#{argv_options[:Host]}:#{argv_options[:Port]}"
      end
    end
    config.eager_load_paths << Rails.root.join("lib")
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.after_initialize do
      Graphiti.setup!
    end
  end
end
