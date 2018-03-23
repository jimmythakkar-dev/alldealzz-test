class CreateEndUserFollowStores < ActiveRecord::Migration
  def change
    create_table :end_user_follow_stores do |t|
      t.integer :end_user_id, null: false
      t.integer :store_id, null: false

      t.timestamps null: false
    end
    add_index :end_user_follow_stores, :end_user_id
    add_index :end_user_follow_stores, :store_id
    add_index :end_user_follow_stores, [:end_user_id, :store_id], unique: true
  end
end
