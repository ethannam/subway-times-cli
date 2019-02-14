class CreateFavoritesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :station_id
      t.string :label
    end
  end
end
