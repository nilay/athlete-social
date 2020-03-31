workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer( ENV["MAX_THREADS"] || ENV["RAILS_MAX_THREADS"] || 1 )
threads threads_count, threads_count

## Heroku recommends setting our puma timeouts according to this guide
# https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts#puma
worker_timeout 15
worker_shutdown_timeout 8

preload_app!

rackup      DefaultRackup
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }


on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
