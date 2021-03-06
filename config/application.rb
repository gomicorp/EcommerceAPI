require_relative 'boot'

require 'rails/all'

ALLOW_LOCALES = %i[ko en vi th].freeze

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'dotenv/load'

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # 추가해줘야 하는 것.
    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('app', 'time_machines')

    # 빼줘야 하는 것.
    config.eager_load_paths -= [Rails.root.join('lib', 'tasks')]
    config.autoload_paths -= [Rails.root.join('lib', 'tasks')]
    config.autoload_paths -= ["#{config.root}/app/simple_office/"]
  end
end
