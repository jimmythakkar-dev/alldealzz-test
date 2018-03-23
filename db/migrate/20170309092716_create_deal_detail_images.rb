class CreateDealDetailImages < ActiveRecord::Migration
  def change
    create_table :deal_detail_images do |t|
    	t.attachment :image
    	t.integer :deal_id
      t.timestamps null: false
    end
  end
end
