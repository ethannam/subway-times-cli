class UpdateTrainsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :trains, :status
    remove_column :trains, :line
  end
end
