require 'httparty'
require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'open-uri'
require 'net/http'
require 'uri'
require 'csv'

class DataHandler
  STATIONS_URL = "http://web.mta.info/developers/data/nyct/subway/Stations.csv"
  HUBS_URL = "http://web.mta.info/developers/data/nyct/subway/StationComplexes.csv"

  def import_routes
    Route.delete_all

    raw = File.open(File.expand_path("../lib/transit_data/routes.txt", __dir__))
    routes = raw.map { |row| row.chomp.split(",") }
    routes.shift # Get rid of header row
    # Fix messed up description rows
    routes.each do |row|
      start = nil
      finish = nil

      row.each_with_index do |value, index|
        start = index if (value.include? "\"") && (start == nil)
        finish = index if (value.include? "\"") && (start != nil)
      end

      description = row[start..finish].join(" ")
      row[start] = description
      row.slice!(start + 1, finish - start)
    end
    
    routes.each { |row| Route.create(mta_id: row[0], agency_id: row[1], short_name: row[2], long_name: row[3], description: row[4], route_type: row[5], url: row[6], color: row[7], text_color: row[8]) }
  end

  def import_lines
    Line.delete_all
    lines = csv(STATIONS_URL).map { |row| row["Line"] }.uniq
    lines.each { |name| Line.create(name: name) }
  end

  def import_stations
    Station.delete_all
    csv(STATIONS_URL).each do |row|
      Station.create(
        hub_id: row["Complex ID"],
        stop_id: row["GTFS Stop ID"],
        division: row["Division"],
        line: row["Line"],
        name: row["Stop Name"],
        borough: row["Borough"],
        daytime_routes: row["Daytime Routes"],
        structure: row["Structure"],
        latitude: row["GTFS Latitude"],
        longitude: row["GTFS Longitude"]
      )
    end
  end

  def import_hubs
    Hub.delete_all
    csv(STATIONS_URL).select { |row| row["Station ID"] == row["Complex ID"] }.each { |row| Hub.create(hub_id: row["Complex ID"], name: row["Stop Name"]) }
    csv(HUBS_URL).each { |row| Hub.create(hub_id: row["Complex ID"], name: row["Complex Name"]) }
  end

  def make_db_connections
    # CONNECT ROUTES TO STATIONS
    RouteStation.delete_all
    Station.all.each do |station|
      station.daytime_routes.split(" ").each do |letter|
        route = Route.find_by(short_name: letter)
        RouteStation.create(route_id: route.id, station_id: station.id)
      end
    end

    # CONNECT LINES TO ROUTES
    LineRoute.delete_all
    lines = csv(STATIONS_URL).inject({}) do |hash, row|
      if hash[row["Line"]]
        row["Daytime Routes"].split(" ").each { |letter| hash[row["Line"]].add(letter) }
      else
        hash[row["Line"]] = row["Daytime Routes"].split(" ").to_set
      end
      hash
    end
    
    lines.each do |row|
      row.second.each do |letter|
        route = Route.find_by(short_name: letter)
        line = Line.find_by(name: row.first)
        LineRoute.create(line_id: line.id, route_id: route.id)
      end
    end
  end

  def fetch_arrivals(station)
    routes = station.daytime_routes.split(" ")
    query = {key: ENV["API_KEY"], feed_id: FeedMapper.new.map(routes.first)}.to_query
    url = "http://datamine.mta.info/mta_esi.php?#{query}"

    data = Net::HTTP.get(URI.parse(url))
    feed = Transit_realtime::FeedMessage.decode(data)

    # Only get the trip updates for the station's daytime routes and convert it to a hash
    trip_updates = feed.entity.select do |entity|
      entity.field?(:trip_update) && (routes.include? entity.trip_update.trip.route_id)
    end.map(&:to_hash)

    # Rebuild the hash and group by route
    trip_updates = trip_updates.inject({}) do |hash, row|
      if hash[row[:trip_update][:trip][:route_id]]
        hash[row[:trip_update][:trip][:route_id]] += row[:trip_update][:stop_time_update]
      else
        hash[row[:trip_update][:trip][:route_id]] = row[:trip_update][:stop_time_update]
      end
      hash
    end

    # Strip out the departure and arrival columns
    trip_updates.each do |route_short_name, updates|
      updates.select! { |hash| hash[:stop_id][0..2] == station.stop_id }.map! do |hash|
        row = { :stop_id => hash[:stop_id] }
        if hash[:arrival]
          row[:time] = hash[:arrival][:time]
        else
          row[:time] = hash[:departure][:time]
        end
        row
      end
    end

    view_arrivals(trip_updates, station.name, group_routes: true)
  end

  private

  def csv(url)
    csv_file = open(url)
    csv = CSV.parse(csv_file, :headers=>true)
  end

  def view_arrivals(data, station_name, limit: 5, group_routes: true)
    north = data.map do |key, value|
      { key => value.select { |hash| hash[:stop_id].include? "N" } }
    end

    north.map! do |hash|
      { 
        hash.keys.first => hash.values.flatten.map do |hash| 
          ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round
        end.select { |number| number >= 0 }.sort
      }
    end

    south = data.map do |key, value|
      { key => value.select { |hash| hash[:stop_id].include? "S" } }
    end

    south.map! do |hash|
      { 
        hash.keys.first => hash.values.flatten.map do |hash| 
          ((Time.at(hash[:time]).getlocal - Time.now.utc)/60).round
        end.select { |number| number >= 0 }.sort
      }
    end

    if group_routes
      north = north.map! do |hash|
        hash.values.flatten.map do |time|
          { hash.keys.first => time }
        end
      end.flatten.sort_by { |hash| hash.values.flatten }[0..limit - 1]

      south = south.map! do |hash|
        hash.values.flatten.map do |time|
          { hash.keys.first => time }
        end
      end.flatten.sort_by { |hash| hash.values.flatten }[0..limit - 1]

      puts "**************** NORTHBOUND TRAINS ****************"
      puts "(LINE)\tWAIT TIME"
      north.each do |hash|
        puts "(#{hash.keys.first})\t#{hash.values.flatten.first} minutes(s)"
      end
      puts "\n"

      puts "**************** SOUTHBOUND TRAINS ****************"
      puts "(LINE)\tWAIT TIME"
      south.each do |hash|
        puts "(#{hash.keys.first})\t#{hash.values.flatten.first} minutes(s)"
      end
      puts "\n"
    else
      # Northbound
      puts "**************** NORTHBOUND TRAINS ****************"
      north.each do |hash|
        times = hash.values.flatten[0..(limit - 1)]

        if times == 0
          puts "There are no northbound (#{hash.keys.first}) trains at this time :("
        else
          puts "The next #{times.length} northbound (#{hash.keys.first}) trains at #{station_name} will arrive in..."
          times.each do |time|
            puts "#{time} minutes(s)"
          end
        end
        puts "\n"
      end

      # Southbound
      puts "**************** SOUTHBOUND TRAINS ****************"
      south.each do |hash|
        times = hash.values.flatten[0..(limit - 1)]

        if times == 0
          puts "There are no southbound (#{hash.keys.first}) trains at this time :("
        else
          puts "The next #{times.length} southbound (#{hash.keys.first}) trains at #{station_name} will arrive in..."
          times.each do |time|
            puts "#{time} minutes(s)"
          end
        end
        puts "\n"
      end
    end
  end
end