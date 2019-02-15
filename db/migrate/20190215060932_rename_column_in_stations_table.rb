class RenameColumnInStationsTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :stations, :complex_id, :hub_id
  end
end
