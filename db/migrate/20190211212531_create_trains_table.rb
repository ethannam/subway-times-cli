class CreateTrainsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :trains do |t|
      t.string :line
      t.string :status
      t.boolean :express
    end
  end
end
