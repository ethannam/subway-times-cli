require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection(
 {
   adapter: 'sqlite3',
   database: 'db/subway_times.sqlite'
 }
)

require_relative '../app/models/station.rb'
require_relative '../app/models/line.rb'
require_relative '../app/models/user.rb'
require_relative '../app/models/favorite.rb'
require_relative '../app/models/route.rb'
require_relative '../app/models/hub.rb'
require_relative '../app/models/route_station.rb'
require_relative '../app/models/line_route.rb'

require_relative '../lib/station_importer.rb'
require_relative '../lib/line_station_importer.rb'
require_relative '../lib/transit_app.rb'
require_relative '../lib/data_handler.rb'

require_relative '../bin/api_call.rb'
