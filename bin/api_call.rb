require 'httparty'
require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'net/http'
require 'uri'

def search_feed(train)
  if train == "1" || train == "2" || train == "3" || train == "4" || train == "5" || train == "6"
    feed_id = 1
  elsif train == "A" || train == "C" || train == "E" || train == "H" || train == "S"
    feed_id = 26
  elsif train == "N" || train == "Q" || train == "R" || train == "W"
    feed_id = 16
  elsif train == "B" || train == "D" || train == "F" || train == "M"
    feed_id = 21
  elsif train == "L"
    feed_id = 2
  elsif train == "SIR"
    feed_id = 11
  elsif train == "G"
    feed_id == 31
  elsif train == "J" || train == "Z"
    feed_id = 36
  elsif train == "7"
    feed_id = 51
  end
end

def url(feed)
  # query = {key: ENV.fetch("MTA_KEY"), feed_id: mta_id}.to_query
  # "http://datamine.mta.info/mta_esi.php?#{query}"

  query = {key: 'dd542468b31829a77225d110c37bbdcf', feed_id: feed}.to_query
  "http://datamine.mta.info/mta_esi.php?#{query}"
end

# def fetch_data
#   data = HTTParty.get(url).body
#   TransitRealtime::FeedMessage.decode(data)
# end

def api_call(train, station, feed)
  data = Net::HTTP.get(URI.parse(url(feed)))
  feed = Transit_realtime::FeedMessage.decode(data)

  my_array = []

  for entity in feed.entity do
    if entity.field?(:trip_update) && (entity.trip_update.trip.route_id == train)
      my_array << entity.trip_update.to_hash
    end
  end


  # Clean the array to only get the stop_id and the time
  my_array.map! { |element| element[:stop_time_update] }.flatten!
  my_array.map! do |hash|
    row = { :stop_id => hash[:stop_id] }
    if hash[:arrival]
      row[:time] = hash[:arrival][:time]
    else
      row[:time] = hash[:departure][:time]
    end
    row
  end

  find_station = Station.find_by(name: station).stop_id


  # Output the estimate time for North
  north = my_array.select { |hash| hash[:stop_id] == find_station + "N" }
  puts "The next 3 northbound #{train} trains at #{station} arrive in..."
  north.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  north[0..2].each { |hash| puts "#{((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round} minute(s)" }

  # Output the estimate time for South
  south = my_array.select { |hash| hash[:stop_id] == find_station + "S" }
  puts "The next 3 southbound #{train} trains at #{station} arrive in..."
  south.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  south[0..2].each { |hash| puts "#{((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round} minutes(s)" }
  puts "Enjoy your ride!"
end
