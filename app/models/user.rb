class User < ActiveRecord::Base
  has_many :favorites
  has_many :stations, through: :favorites

  # Required keywords station and label
  def add_favorite(station:, label:)
    Favorite.create(
      user_id: self.id, 
      station_id: station.id, 
      label: label
    )
  end
end