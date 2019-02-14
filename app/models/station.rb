class Station < ActiveRecord::Base
  has_many :arrivals
  has_many :favorites
  has_many :trains, through: :arrivals
  has_many :lines, through: :line_stations
  has_many :users, through: :favorites
end