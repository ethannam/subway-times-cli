class CreateRouteStationsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :route_stations do |t|
      t.integer :route_id
      t.integer :station_id
    end
  end
end
