require_relative '../config/environment.rb'

ActiveRecord::Base.logger.level = 1

TransitApp.start
