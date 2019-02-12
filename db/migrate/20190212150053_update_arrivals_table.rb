class UpdateArrivalsTable < ActiveRecord::Migration[5.2]
  def change
    change_column :arrivals, :time, :datetime
  end
end
