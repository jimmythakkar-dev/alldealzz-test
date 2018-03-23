class CreateDealAnalytics < ActiveRecord::Migration
  def change
    create_table :deal_analytics do |t|
      t.integer :deal_id
      t.integer :user_id
      t.integer :type

      t.timestamps null: false
    end
  end
end
