class AddMaxBookingsToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :max_bookings, :integer
  end
end
