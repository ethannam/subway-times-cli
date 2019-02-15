class RecreateStationsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.integer :complex_id
      t.string :stop_id
      t.string :division
      t.string :line
      t.string :name
      t.string :borough
      t.string :daytime_routes
      t.string :structure
      t.float :latitude
      t.float :longitude
    end
  end
end
