require File.expand_path("../boot", __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pros
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: ENV["POSTMARK_API_TOKEN"] }

  end
end
