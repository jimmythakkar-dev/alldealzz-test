class SalesUserStore < ActiveRecord::Migration
  def change
    create_table :sales_user_stores do |t|
      t.integer :sales_user_id
      t.string :name
      t.attachment :logo
      t.attachment :cover_pic
      t.integer :latitude
      t.integer :longitude
      t.string :address_line_one
      t.string :address_line_two
      t.string :phone_number
      t.string :authorized_person_name
      t.string :email
      t.string :start_time
      t.string :end_time
      t.string :working_days
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end
