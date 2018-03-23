class CreateEndUserDealReviews < ActiveRecord::Migration
  def change
    create_table :end_user_deal_reviews do |t|
      t.integer :end_user_id, null: false
      t.integer :deal_id, null: false
      t.text :message
      
      t.timestamps null: false
    end
  end
end
