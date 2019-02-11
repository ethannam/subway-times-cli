class AddColumnsToArrivalsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :arrivals, :train_id, :integer
    add_column :arrivals, :station_id, :integer
  end
end
