class CreateQuota < ActiveRecord::Migration
  def change
    create_table :quota do |t|
      t.integer :store_id
      t.integer :total
      t.integer :used
      t.integer :premium_notification_total
      t.integer :premium_notification_used

      t.timestamps null: false
    end
  end
end
