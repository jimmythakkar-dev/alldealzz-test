class CreateFeedDetailImages < ActiveRecord::Migration
  def change
    create_table :feed_detail_images do |t|
    	t.attachment :image
    	t.integer :feed_id
      t.timestamps null: false
    end
  end
end
