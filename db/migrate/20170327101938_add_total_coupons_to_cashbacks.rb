class AddTotalCouponsToCashbacks < ActiveRecord::Migration
  def change
  	add_column :cashbacks, :total_coupons, :integer
  end
end
