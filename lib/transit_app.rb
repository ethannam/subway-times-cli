class TransitApp
  def self.start
    welcome

    loop do
      show_menu
      command = get_user_command

      case command
      when "LOGIN"
        user = login
        if user
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
    puts "What train are you looking for?"
    train_request = gets.chomp!
    feed_id = search_feed(train_request)
    url(feed_id)
    puts "At what station?"
    station_request = gets.chomp!
    api_call(train_request, station_request, feed_id)
  end
end