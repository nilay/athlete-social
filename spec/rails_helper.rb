ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start :rails do
  add_group "Jobs", "app/jobs"
  add_group "Services", "app/services"
end

require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("Rails environment is set to production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

require "webmock/rspec"
require "shoulda/matchers"
require "factory_girl_rails"
require "webmock/rspec"
require "challah/test"
require "timecop"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you"re not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.render_views = true

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  config.order = "random"

  config.before(:each) do
    # Clear redis cache before each test
    REDIS.flushdb
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
