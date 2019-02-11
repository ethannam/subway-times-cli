class Line < ActiveRecord::Base
  has_many :stations
  has_many :trains
end