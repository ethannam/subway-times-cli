class CreateLineStationsTableAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :line_stations do |t|
      t.integer "line_id"
      t.integer "station_id"
    end
  end
end
