require_relative '../config/environment.rb'

ActiveRecord::Base.logger.level = 1

binding.pry
# DataHandler.new.import_hubs(refresh: true)

# TransitApp.start
