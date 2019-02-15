require_relative '../config/environment.rb'

ActiveRecord::Base.logger.level = 1

# bowling_green = Station.find_by(name: "Bowling Green")
# DataHandler.new.fetch_arrivals(bowling_green)
# DataHandler.new.fetch_arrivals(QueryHandler.new.find_station("Fulton St"))

TransitApp.start
