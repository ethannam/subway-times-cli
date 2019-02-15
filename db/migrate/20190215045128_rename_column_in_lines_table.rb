class RenameColumnInLinesTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :lines, :mta_name, :route_id
    change_column :lines, :route_id, :integer
  end
end
