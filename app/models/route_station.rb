class RouteStation < ActiveRecord::Base
  belongs_to :routes
  belongs_to :stations
end