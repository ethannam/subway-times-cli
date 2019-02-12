require 'rest-client'

def import_stations
  # Get stations array
  # result_string = File.read(File.expand_path("../../json/subway_stations.json", __FILE__))
  result_string = RestClient.get('https://data.cityofnewyork.us/api/views/kk4q-3rt2/rows.json?accessType=DOWNLOAD')
  result_hash = JSON.parse(result_string)
  stations_array = result_hash["data"]

  # Create a hash to get information we care about
  stations_array.inject({}) do |hash, station|
    name = station[10]
    latitude = station[11].slice(-18,17)
    longitude = station[11].slice(7,18)
    lines = station[12].split(" ")[0].split("-").uniq
    hash[name] = {latitude: latitude, longitude: longitude, lines: lines}
    hash
  end
end