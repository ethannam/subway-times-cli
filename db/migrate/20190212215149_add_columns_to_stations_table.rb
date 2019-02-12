class AddColumnsToStationsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :stop_id, :string
    add_column :stations, :location_type, :boolean
    add_column :stations, :parent_station, :string
  end
end
