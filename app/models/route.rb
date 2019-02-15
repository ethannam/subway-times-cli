class Route < ActiveRecord::Base
  has_many :route_stations
  has_many :stations, through: :route_stations

  def add_station(station)
    # RouteStation.create(line_id: self.id, station_id: station.id)
  end
end