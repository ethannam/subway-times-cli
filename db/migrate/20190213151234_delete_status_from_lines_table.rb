class DeleteStatusFromLinesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :lines, :status
  end
end
