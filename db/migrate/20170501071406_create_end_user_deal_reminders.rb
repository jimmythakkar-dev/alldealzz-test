class CreateEndUserDealReminders < ActiveRecord::Migration
  def change
    create_table :end_user_deal_reminders do |t|
      t.integer :end_user_id, null: false
      t.integer :deal_id, null: false
      t.datetime :reminder_time
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end
