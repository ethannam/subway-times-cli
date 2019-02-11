class LineStation < ActiveRecord::Base
  belongs_to :stations
  belongs_to :lines
end