class Train < ActiveRecord::Base
  has_many :arrivals
  has_many :stations, through: :arrivals
  belongs_to :lines
end