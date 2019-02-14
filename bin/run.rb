require_relative '../config/environment.rb'
require_relative '../lib/station_importer.rb'
require_relative '../lib/line_station_importer.rb'
require_relative '../bin/api_call.rb'

puts "Hello, world. Welcome to Subway Times."
puts "User Login"
login = gets.chomp!
puts "What train are you looking for?"
train_request = gets.chomp!
feed_id = search_feed(train_request)
url(feed_id)
puts "At what station?"
station_request = gets.chomp!
api_call(train_request, station_request, feed_id)
# binding.pry
