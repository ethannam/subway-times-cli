class QueryHandler
  def find_station(station_name)
    results = Hub.where(name: station_name)
    if results.length == 0
      false
    elsif results.length == 1
      Station.find_by(hub_id: results.first.hub_id)
    else
      handle_hub(results)
    end
  end

  def handle_hub(hubs)
    choices = hubs.map { |hub| { hub => Station.where(hub_id: hub.hub_id) } }

    hubs.each_with_index do |hub, index|
      stations = Station.where(hub_id: hub.hub_id)
      routes = format_routes(stations.map {|station| station.daytime_routes }.join (" "))
      puts "#{index + 1}. #{hub.name} #{routes}"
    end

    input = 0
    loop do
      puts "Enter the number of the station you want:"
      input = gets.chomp.to_i
      break if (input > 0 && input <= hubs.length)
    end

    selected_hub = choices.at(input - 1).values.flatten

    if selected_hub.length == 1
      selected_hub.first
    else
      selected_hub.each_with_index do |station, index|
        puts "#{index + 1}. #{station.name} #{station.daytime_routes}"
      end

      loop do
        puts "Enter the number of the lines that you want for this station:"
        input = gets.chomp.to_i
        break if (input > 0 && input <= selected_hub.length)
      end

      selected_hub.at(input - 1)
    end
  end

  private

  def format_routes(route_string)
    route_string.split(" ").map { |string| "(#{string})"}.join(" ") + " ".chop
  end


end