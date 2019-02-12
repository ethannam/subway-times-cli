def import_stations
  result_string = File.read(File.expand_path("../../json/subway_stations.json", __FILE__))
  result_hash = JSON.parse(result_string)
  stations_array = result_hash["data"]
end