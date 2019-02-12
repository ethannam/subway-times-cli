require 'httparty'
require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'net/http'
require 'uri'

def url
  # query = {key: ENV.fetch("MTA_KEY"), feed_id: mta_id}.to_query
  # "http://datamine.mta.info/mta_esi.php?#{query}"

  query = {key: 'dd542468b31829a77225d110c37bbdcf', feed_id: 1}.to_query
  "http://datamine.mta.info/mta_esi.php?#{query}"
end

def fetch_data
  data = HTTParty.get(url).body
  TransitRealtime::FeedMessage.decode(data)
end

def api_call

  data = Net::HTTP.get(URI.parse(url))
  feed = Transit_realtime::FeedMessage.decode(data)
  # for entity in feed.entity do
  #   if entity.field?(:trip_update)
  #     p entity.trip_update
  #   end
  # end

  binding.pry

  # data = fetch_data
  # binding.pry
end