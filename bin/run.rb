require_relative '../config/environment.rb'

ActiveRecord::Base.logger.level = 1

DataHandler.new.import_hubs(refresh: true)

binding.pry
# TransitApp.start
