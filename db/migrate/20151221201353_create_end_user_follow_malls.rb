class CreateEndUserFollowMalls < ActiveRecord::Migration
  def change
    create_table :end_user_follow_malls do |t|
      t.integer :end_user_id, null: false
      t.integer :mall_id, null: false

      t.timestamps null: false
    end
    add_index :end_user_follow_malls, :end_user_id
    add_index :end_user_follow_malls, :mall_id
    add_index :end_user_follow_malls, [:end_user_id, :mall_id], unique: true
  end
end
