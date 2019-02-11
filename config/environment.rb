require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection(
 {
   adapter: 'sqlite3',
   database: 'db/subway_times.sqlite'
 }
)

require_relative '../app/models/train.rb'
require_relative '../app/models/station.rb'
require_relative '../app/models/arrival.rb'
require_relative '../app/models/line.rb'
