class RedropLineStationsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :line_stations
  end
end
