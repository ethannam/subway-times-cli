class DropArrivalsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :arrivals
  end
end
