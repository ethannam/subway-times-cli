require 'rest-client'

def import_stations
  # Get stations array
  result_string = RestClient.get('https://data.cityofnewyork.us/api/views/kk4q-3rt2/rows.json?accessType=DOWNLOAD')
  result_hash = JSON.parse(result_string)
  stations_array = result_hash["data"]

  # Create a hash to get information we care about
  our_hash = stations_array.inject({}) do |hash, station|
    name = station[10]
    latitude = station[11].slice(-18,17)
    longitude = station[11].slice(7,18)
    lines = station[12].split(" ")[0].split("-").uniq

    # hash[name] = {latitude: latitude, longitude: longitude, lines: lines}
    if hash[name]
      hash[name][:lines] = hash[name][:lines] + lines
    else
      hash[name] = {latitude: latitude, longitude: longitude, lines: lines}
    end
    
    hash
  end

  # Iterate through the hash and create the stations and associate them with lines
  our_hash.each do |station, attributes|
    new_station = Station.create(name: station, latitude: attributes[:latitude], longitude: attributes[:longitude])

    attributes[:lines].each do |line|
      current_line = Line.find_by(name: line)
      current_line.add_station(new_station, "Running")
    end
  end
end