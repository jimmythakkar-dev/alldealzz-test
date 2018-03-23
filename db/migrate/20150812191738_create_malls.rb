class CreateMalls < ActiveRecord::Migration
  def change
    create_table :malls do |t|
			t.string :name
      t.string :phone
      t.string :city
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :radius, default: 0
      t.text :address
      t.string :contact_phone
      t.string :contact_persone
      t.boolean :status
      t.string :location
      t.integer :category_id
      t.integer :user_id
      t.attachment :logo
      t.datetime :expiry_date
      t.integer :duration
      t.integer :store_quota, default: 0

      t.timestamps null: false
    end
    add_column :stores, :manageable_id, :integer
    add_column :stores, :manageable_type, :string
  end
end
