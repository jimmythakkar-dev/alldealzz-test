class AddStatusField < ActiveRecord::Migration
  def change
    add_column :deals, :status, :boolean
    add_column :premium_notifications, :status, :boolean
    add_column :stores, :expiry_date, :datetime
    add_column :stores, :duration, :integer
  end
end
