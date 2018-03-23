class AddRedeemedAtToBookingCodes < ActiveRecord::Migration
  def up
    add_column :booking_codes, :redeemed_at, :datetime
  	remove_column :requested_notifications, :target_doorkeeper_access_token_id
  end

  def down
    remove_column :booking_codes, :redeemed_at
   	add_column :requested_notifications, :target_doorkeeper_access_token_id, :integer
  end
end
