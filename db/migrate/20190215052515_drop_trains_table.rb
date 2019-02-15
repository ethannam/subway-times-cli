class DropTrainsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :trains
  end
end
