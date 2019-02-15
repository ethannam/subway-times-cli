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

def url(feed_id)
  # query = {key: ENV.fetch("MTA_KEY"), feed_id: mta_id}.to_query
  # "http://datamine.mta.info/mta_esi.php?#{query}"

  query = {key: ENV["API_KEY"], feed_id: feed_id}.to_query
  "http://datamine.mta.info/mta_esi.php?#{query}"
end

# def fetch_data
#   data = HTTParty.get(url).body
#   TransitRealtime::FeedMessage.decode(data)
# end

def api_call(station)
  line = Line.find(LineStation.find_by(station_id: station.id).line_id)
  feed_id = search_feed(line.name)

  data = Net::HTTP.get(URI.parse(url(feed_id)))
  feed = Transit_realtime::FeedMessage.decode(data)

  my_array = []

  for entity in feed.entity do
    if entity.field?(:trip_update) && (entity.trip_update.trip.route_id == line.name)
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

  stop_id = station.stop_id

  # Output the estimate time for North
  north = my_array.select { |hash| hash[:stop_id] == stop_id + "N" }
  puts "\n"
  puts "The next 3 northbound #{line.name} trains at #{station.name} arrive in..."
  north.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  north[0..2].each { |hash| puts "#{((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round} minute(s)" }

  # Output the estimate time for South
  south = my_array.select { |hash| hash[:stop_id] == stop_id + "S" }
  puts "\n"
  puts "The next 3 southbound #{line.name} trains at #{station.name} arrive in..."
  south.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  south[0..2].each { |hash| puts "#{((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round} minutes(s)" }
  puts "\n"
  puts "Enjoy your ride!"
end
