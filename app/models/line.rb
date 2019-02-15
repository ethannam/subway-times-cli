class Line < ActiveRecord::Base
  has_many :line_routes
  has_many :routes, through: :lines
end
