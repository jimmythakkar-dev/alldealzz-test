class AddHasBookingCodesToMerchantUsers < ActiveRecord::Migration
  def change
    add_column :merchant_users, :has_booking_codes, :boolean, default: false
  end
end
