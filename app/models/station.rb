class Station < ActiveRecord::Base
  has_many :arrivals
  has_many :trains, through: :arrivals
  has_many :lines, through: :line_stations
end