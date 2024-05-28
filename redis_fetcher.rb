require 'redis'
require 'json'

class RedisFetcher
  def initialize(redis = Redis.new)
    @redis = redis
  end

  def fetch_data
    @redis.keys.each_with_object({}) do |url, data|
      value = @redis.get(url)
      next unless value

      begin
        data[url] = JSON.parse(value)
      rescue JSON::ParserError
        puts "Skipping key #{url}: invalid JSON."
      end
    end
  end
end
