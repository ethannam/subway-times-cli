class Arrival < ActiveRecord::Base
  belongs_to :trains
  belongs_to :stations

  def eta
    ((self.time - Time.now.utc)/60).round
  end

end