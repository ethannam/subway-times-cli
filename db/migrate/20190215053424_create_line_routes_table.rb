class CreateLineRoutesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :line_routes do |t|
      t.integer :line_id
      t.integer :route_id
    end
  end
end
