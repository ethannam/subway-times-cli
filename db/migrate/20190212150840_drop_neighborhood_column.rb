class DropNeighborhoodColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :stations, :neighborhood
  end
end
