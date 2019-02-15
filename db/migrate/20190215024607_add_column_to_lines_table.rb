class AddColumnToLinesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :lines, :mta_name, :string
  end
end
