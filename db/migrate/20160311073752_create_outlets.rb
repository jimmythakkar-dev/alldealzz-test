class CreateOutlets < ActiveRecord::Migration
  def change
    create_table :outlets do |t|
      t.integer :store_id
      t.text :address
      t.string :contact_phone
      t.string :contact_person
      t.boolean :status
      t.string :location
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :radius
      t.string :locality
      t.integer :duration

      t.timestamps null: false
    end
  end
end
