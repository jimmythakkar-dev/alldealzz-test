class CreatePremiumNotifications < ActiveRecord::Migration
  def change
    create_table :premium_notifications do |t|
      t.integer :store_id
      t.integer :deal_category_id
      t.text :notification_text
      t.decimal :radius
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :publish
      t.datetime :publish_date
      t.integer :duration
      t.datetime :notification_time_from
      t.datetime :notification_time_to
      t.string :days

      t.timestamps null: false
    end
  end
end
