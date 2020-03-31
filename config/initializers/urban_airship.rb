require "urbanairship/default_client_configuration"

UrbanAirship = Urbanairship

UrbanAirship.configure do |config|
  config.application_key = ENV["URBAN_AIRSHIP_ID"]
  config.master_secret   = ENV["URBAN_AIRSHIP_SECRET"]
end
