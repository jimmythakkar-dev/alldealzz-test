class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :store_id
      t.integer :deal_category_id
      t.string :main_line
      t.text :description
      t.text :notification_text
      t.decimal :notification_radius
      t.string :gender
      t.boolean :is_age_limit
      t.integer :age_from
      t.integer :age_to
      t.boolean :publish
      t.datetime :publish_date
      t.integer :duration
      t.datetime :notification_time_from
      t.datetime :notification_time_to
      t.string :days
      t.boolean :is_coupon
      t.string :coupon_text
      t.attachment :coupon_image
      t.attachment :main_image
      t.attachment :featured_image

      t.timestamps null: false
    end
  end
end
