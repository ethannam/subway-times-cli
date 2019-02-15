class QueryHandler
  def find_station(station_name)
    results = Station.where(name: station_name)
    if results.length == 0
      false
    elsif results.length == 1
      results.first
    else
      handle_hub(results)
    end
  end

  def handle_hub(stations)
    hubs = stations.map { |hub| Hub.find_by(hub_id: hub.hub_id) }.uniq!
    hubs.length == 1 ? get_route_choice(stations) : get_station_choice(hubs)
  end

  private

  def format_routes(route_string)
    route_string.split(" ").map { |string| "(#{string})"}.join(" ") + " ".chop
  end

  def get_route_choice(stations)
    if stations.length == 1
      Station.find_by(stop_id: stations.first.stop_id)
    else
      stations.each_with_index do |station, index|
        puts "#{index + 1}. The #{format_routes(station.daytime_routes)} at #{station.name}"
      end

      input = nil
      loop do
        puts "Enter the number of the routes that you want for this station:"
        input = gets.chomp.to_i
        break if (input > 0 && input <= stations.length)
      end

      stations[input - 1]
    end
  end

  def get_station_choice(hubs)
    choices = hubs.map { |hub| { hub => Station.where(hub_id: hub.hub_id) } }

    hubs.each_with_index do |hub, index|
      stations = Station.where(hub_id: hub.hub_id)
      routes = format_routes(stations.map {|station| station.daytime_routes }.join (" "))
      puts "#{index + 1}. #{hub.name} #{routes}"
    end

    input = nil
    loop do
      puts "Enter the number of the station you want:"
      input = gets.chomp.to_i
      break if (input > 0 && input <= hubs.length)
    end

    stations = choices.at(input - 1).values.flatten
    get_route_choice(stations)
  end
end