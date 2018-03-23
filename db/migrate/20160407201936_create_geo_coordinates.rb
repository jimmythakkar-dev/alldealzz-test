class CreateGeoCoordinates < ActiveRecord::Migration
  def change
    create_table :geo_coordinates do |t|
    	t.references :locationable, polymorphic: true, index: true
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps null: false
    end
    remove_column :stores, :has_outlets, :boolean, null: false, default: false
  	remove_column :deals, :outlet_ids, :string
  end
end
