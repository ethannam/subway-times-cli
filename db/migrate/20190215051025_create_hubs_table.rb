class CreateHubsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :hubs do |t|
      t.integer :hub_id
      t.string :name
    end
  end
end
