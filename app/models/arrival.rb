class Arrival < ActiveRecord::Base
  belongs_to :trains
  belongs_to :stations
end