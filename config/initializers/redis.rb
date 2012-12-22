uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://0.0.0.0:6379/" )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS