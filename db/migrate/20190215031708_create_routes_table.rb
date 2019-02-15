class CreateRoutesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :routes do |t|
      t.string :mta_id
      t.string :agency_id
      t.string :short_name
      t.string :long_name
      t.string :description
      t.string :route_type
      t.string :url
      t.string :color
      t.string :text_color
    end
  end
end
