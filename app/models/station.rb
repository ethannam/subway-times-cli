class Station < ActiveRecord::Base
  has_many :favorites
  has_many :users, through: :favorites

  has_many :route_stations
  has_many :routes, through: :route_stations
end