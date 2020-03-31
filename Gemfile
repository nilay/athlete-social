source "https://rubygems.org"

ruby "2.3.1"

gem 'rails', '~> 5.0.0.rc1'
gem "pg", "~> 0.18"
gem "puma"

# Waiting for Rails 5 Compatibility
gem "acts_as_follower", github: "ovenbits/acts_as_follower",    ref: "c7845342"
gem "challah",          github: "ovenbits/challah",             branch: "commit-08b0d916"
gem "paperclip",        github: "thoughtbot/paperclip",         ref: "523bd46c"
gem "ransack",          github: "activerecord-hackery/ransack", ref: "3258d255"

gem "acts-as-taggable-on"
gem "acts_as_votable", "~> 0.10.0"
gem "autoprefixer-rails"
gem "aws-sdk"
gem "cancancan", "~> 1.13"
gem "challah-facebook"
gem "connection_pool"
gem "dalli"
gem "faker"
gem "flux-rails-assets"
gem "haml-rails", "~> 0.9"
gem "jbuilder", "~> 2.6.1"
gem "jbuilder_cache_multi"
gem "jquery-rails"
gem "kaminari"
gem "koala"
gem "newrelic_rpm"
gem "postmark-rails", ">= 0.10.0"
gem "rack-timeout"
gem "react-rails", "~> 1.6.0"
gem "redis", "~> 3.0"
gem 'redis-namespace'
gem "sass-rails", "~> 5.0"
gem "sidekiq"
gem "sinatra", github: "sinatra", require: false
gem "slim"
gem "simple_form"
gem 'sprockets-es6', '~> 0.9.0'
gem "uglifier", ">= 1.3.0"
gem "telestream_cloud"
gem "twilio-ruby"
gem "unirest", github: "ovenbits/unirest-ruby", ref: "bf47ddd"
gem "urbanairship"


# following two gems fails while installation.
#gem "hirefire"
#gem "hirefire-resource"

gem "ruby-uploader"

group :development, :test do
  gem "database_cleaner", "~> 1.2.0"
  gem "better_errors"
  gem "byebug"
  gem "dotenv-rails"
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-stack_explorer"
  gem "spring-commands-rspec"
  gem "rspec-rails",            github: "rspec/rspec-rails", tag: "v3.5.0.beta3"
  gem "rspec-core",             github: "rspec/rspec-core", tag: "v3.5.0.beta3"
  gem "rspec-expectations",     github: "rspec/rspec-expectations", tag: "v3.5.0.beta3"
  gem "rspec-mocks",            github: "rspec/rspec-mocks", tag: "v3.5.0.beta3"
  gem "rspec-support",          github: "rspec/rspec-support", tag: "v3.5.0.beta3"
end


group :staging, :development, :test do
  gem "factory_girl_rails"
end

group :development do
  gem "annotate"
  gem "quiet_assets"
  gem "web-console", "~> 3.0"
  gem "rubocop", "0.36"
end

group :test do
  # capybara and capybara-webkit fails while installation
  gem "capybara", "~> 2.5"
  gem "capybara-webkit", "~> 1.8"

  gem "shoulda-matchers", "~> 3.1"
  gem "simplecov", require: false
  gem "timecop", require: false
  gem "webmock", require: false
  gem "rails-controller-testing"
  gem "json_matchers"
end

group :production do
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "lograge"
end
