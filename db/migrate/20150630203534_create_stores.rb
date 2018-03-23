class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :phone
      t.string :city
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :radius
      t.text :address
      t.string :contact_phone
      t.string :contact_persone
      t.boolean :status
      t.string :location
      t.integer :store_category_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
