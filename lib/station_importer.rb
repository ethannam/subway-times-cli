class StationImporter
  def self.import
    # Read in text file
    stops_array = File.open(File.expand_path('../lib/transit_data/stops.txt', __dir__)).map do |line|
      line.chomp.split(',')
    end
    stops_array.shift

    # Iterate through array and fill database
    stops_array.each do |stop|
      stop_id = stop[0]
      name = stop[2]
      latitude = stop[4]
      longitude = stop[5]
      location_type = (stop[8].eql? "1") ? true : false
      parent_station = stop[9] ? stop[9] : nil
      Station.create(name: name, latitude: latitude, longitude: longitude, location_type: location_type, parent_station: parent_station, stop_id: stop_id)
    end
  end
end