class CreateEndUsers < ActiveRecord::Migration
  def change
    create_table :end_users do |t|
      t.text :name
      t.string :email
      t.integer :age
      t.string :gender
      t.boolean :device_type
      t.text :pn_id
      t.integer :latitude
      t.integer :longitude
      t.string :uid
      t.string :auth_account
      t.attachment :photo

      t.timestamps null: false
    end
  end
end
