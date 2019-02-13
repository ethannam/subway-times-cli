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

# def fetch_data
#   data = HTTParty.get(url).body
#   TransitRealtime::FeedMessage.decode(data)
# end

def api_call
  data = Net::HTTP.get(URI.parse(url))
  feed = Transit_realtime::FeedMessage.decode(data)
  
  my_array = []

  for entity in feed.entity do
    # binding.pry
    # my_hash = entity.to_hash

    if entity.field?(:trip_update) && (entity.trip_update.trip.route_id == "4" || entity.trip_update.trip.route_id == "5")
      my_array << entity.trip_update.to_hash
      # my_array << entity.trip_update.stop_time_update.map do |row|
      #   {
      #     :stop_id => row[:stop_id],
      #     :arrival_time => row[:arrival][:time]
      #   }
      # end
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

  # Output the estimate time for Bowling Green North
  bg_north = my_array.select { |hash| hash[:stop_id] == "420N" }
  puts "The next 3 northbound trains at Bowling Green arrive in these minutes: ..."
  bg_north.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  bg_north[0..2].each { |hash| puts ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round }

  # Output the estimate time for Bowling Green South
  bg_south = my_array.select { |hash| hash[:stop_id] == "420S" }
  puts "The next 3 southbound trains at Bowling Green arrive in these minutes: ..."
  bg_south.select! { |hash| ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round > 0 }
  bg_south[0..2].each { |hash| puts ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round }
  "Enjoy your ride!"
end


