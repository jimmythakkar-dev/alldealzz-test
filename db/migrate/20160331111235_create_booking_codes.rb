class CreateBookingCodes < ActiveRecord::Migration
  def change
    create_table :booking_codes do |t|
      t.string :coupon_code
      t.integer :merchant_user_id
      t.boolean :redeemed, default: false

      t.timestamps null: false
    end
    add_index :booking_codes, :coupon_code, unique: true
  end
end
