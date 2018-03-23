class AddExpiryDateToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :expiry_date, :datetime
  end
end
