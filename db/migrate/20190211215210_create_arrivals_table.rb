class CreateArrivalsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :arrivals do |t|
      t.time :time
    end
  end
end
