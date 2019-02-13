class LineStationImporter
  def self.import
    # Read in text file
    stops = File.open(File.expand_path('../lib/transit_data/stops.txt', __dir__)).map do |line|
      line.chomp.split(',')
    end
    
    stops.shift # Delete headers
    stops.map! { |stop| [properly_map(stop.first[0]), stop.first] } # Get properly mapped name and stop_id
    stops = stops.select { |stop| stop.second.length == 3 } # Get only parent stations

    stops.each do |stop|
      line = Line.find_by(name: stop.first)
      station = Station.find_by(stop_id: stop.second)
      line.add_station(station)
    end
  end

  private

  def self.properly_map(line_name)
    case line_name
    when "9"
      return "S"
    when "S"
      return "SIR"
    when "H"
      return "A"
    else
      return line_name
    end
  end
end

