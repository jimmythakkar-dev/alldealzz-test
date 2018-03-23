class AddActualPriceAndDiscountedPriceToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :price, :decimal, precision:  10, scale:  2
    add_column :deals, :discounted_price, :decimal, precision:  10, scale:  2
  end
end
