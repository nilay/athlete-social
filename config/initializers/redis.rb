if provider = ENV["REDIS_PROVIDER"]
  url = ENV[provider]
else
  url = ENV["REDISCLOUD_URL"]     ||
        ENV["REDISTOGO_URL"]      ||
        ENV["REDIS_URL"]          ||
        "redis://localhost:6379"
end

db  = Rails.env.test? ? 1 : 0

REDIS_CONNECTION = Redis.new(url: url)
REDIS_CONNECTION.select(db)

Redis.current = REDIS_CONNECTION

REDIS = Redis::Namespace.new(:pros, redis: Redis.current)
