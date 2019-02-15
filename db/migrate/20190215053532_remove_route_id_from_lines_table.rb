class RemoveRouteIdFromLinesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :lines, :route_id
  end
end
