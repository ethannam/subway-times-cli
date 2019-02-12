class Line < ActiveRecord::Base
  has_many :trains
  has_many :stations, through: :line_stations

  def add_station(station, status)
    LineStation.create(station_id: station.id, line_id: self.id, status: status)
  end
  
end
