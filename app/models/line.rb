class Line < ActiveRecord::Base
  has_many :trains
  has_many :stations, through: :line_stations

  def add_station(station)
    LineStation.create(line_id: self.id, station_id: station.id)
  end
end
