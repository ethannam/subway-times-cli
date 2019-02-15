class DropHubsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :hubs
  end
end
