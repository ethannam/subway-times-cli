class TransitApp
  @user = nil

  def self.start
    welcome

    loop do
      show_menu
      command = get_user_command

      case command
      when "LOGIN"
        @user = login
        if @user
          user_navigation
          break
        else
          puts "\n"
          puts "You entered an incorrect username."
        end
      when "REGISTER"
        register
      when "HELP"
      when "QUIT"
      else
        puts "\n"
        puts "Please enter a valid command."
      end

      break if command.eql? "QUIT"
    end

    say_goodbye
  end

  private

  def self.welcome
    puts "Welcome to CL Subway Times."
  end

  def self.say_goodbye
    puts "Goodbye!"
  end

  def self.show_menu
    puts "\n"
    puts "Available commands:"
    puts "LOGIN"
    puts "REGISTER"
    puts "HELP"
    puts "QUIT"
    puts "\n"
  end

  def self.get_user_command
    puts "Enter a command:"
    command = gets.chomp
  end

  def self.login
    puts "Enter your username:"
    input = gets.chomp
    result = User.find_by(username: input)
    result ? result : false
  end

  def self.register
    username, first_name, last_name, answer = "", "", "", ""

    loop do
      puts "Enter your desired username:"
      username = gets.chomp
      puts "Enter your first name:"
      first_name = gets.chomp
      puts "Enter your last name:"
      last_name = gets.chomp

      puts "Your desired username: #{username}"
      puts "Your first name: #{first_name}"
      puts "Your last name: #{last_name}"

      puts "Register? Type 'YES' or 'NO'"
      answer = gets.chomp

      break if answer.eql? "YES"
    end

    User.create(username: username, first_name: first_name, last_name: last_name)
    puts "\n"
    puts "User #{username} has been created!"
  end

  def self.user_navigation
    loop do
      user_nav_menu
      command = get_user_command

      case command
      when "SEARCH"
        result = search
        if confirm_add.eql? true
          label = get_label
          @user.add_favorite(station: result, label: label)
        end
      when "FAVORITES"
        favorites
      when "HELP"
      when "QUIT"
      else
        puts "\n"
        puts "Please enter a valid command."
      end

      break if command.eql? "QUIT"
    end
  end

  def self.user_nav_menu
    puts "\n"
    puts "Available commands:"
    puts "SEARCH"
    puts "FAVORITES"
    puts "HELP"
    puts "QUIT"
    puts "\n"
  end

  def self.search
    station_result = []
    station = nil

    loop do
      puts "What station are you looking for?"
      station_query = gets.chomp
      station_result = Station.where(name: station_query, parent_station: nil)
      if station_result.length.eql? 0
        puts "\n"
        puts "That station doesn't exist. Try again."
      end
      break if station_result.length > 0
    end

    if station_result.length.eql? 1
      station = station_result.first
      api_call(station)
    else
      lines = station_result.map do |station|
        Line.find(LineStation.find_by(station_id: station.id).line_id)
      end

      loop do
        puts "Choose a line for this station:"
        lines.each { |line| puts line.name }
        input = gets.chomp
        result = Line.find_by(name: input)

        if result == nil
          puts "\n"
          puts "Choose a valid line please."
        else
          station = station_result.select do |station|
            LineStation.find_by(line_id: result.id, station_id: station.id)
          end.first
          api_call(station)
        end
        break if (result != nil)
      end
    end
    station
  end

  def self.confirm_add
    puts "Type 'ADD' to add to your favorites."
    input = gets.chomp
    input == "ADD" ? true : false
  end

  def self.get_label
    puts "Enter a label for this station? (Home, Work, etc.):"
    input = gets.chomp
  end

  def self.favorites
    puts "\n"
    puts "Here are your favorites:"
    Favorite.where(user_id: @user.id).each do |favorite|
      station = Station.find(favorite.station_id)
      puts "#{favorite.label}: #{station.name}"
    end
  end
end