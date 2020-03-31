if Rails.env.production?
  Rack::Timeout.timeout = 15
  Rack::Timeout.wait_timeout = 15
end
