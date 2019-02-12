class Line < ActiveRecord::Base
  has_many :trains
  has_many :stations, through: :line_stations

  def add_station(station, status)
    LineStation.create(station_id: station.id, line_id: self.id, status: status)
  end

  # station_name = import_stations[0][10]
  # station_lat = import_stations[0][11].slice(-18,17)
  # station_long = import_stations[0][11].slice(7,18)
  # station_lines = import_stations[0][12].split(" ")[0].split("-").uniq
  
end
