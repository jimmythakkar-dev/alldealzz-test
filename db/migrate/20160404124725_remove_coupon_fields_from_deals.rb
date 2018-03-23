class RemoveCouponFieldsFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :is_coupon
    remove_column :deals, :coupon_text
    remove_column :deals, :coupon_image_file_name
    remove_column :deals, :coupon_image_file_size
    remove_column :deals, :coupon_image_updated_at
  end
end
