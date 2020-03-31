Sidekiq.configure_server do |config|
  config.redis = { namespace: "pros" }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: "pros" }
end

Sidekiq::Logging.logger.level = ::Logger::WARN
