class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
    	t.boolean       :status, default: true
      t.references    :store, null: false
      t.integer    		:valid_at, default: 0
      t.integer    		:feed_type, default: 0
      t.string        :title
      t.text          :description
      t.text      		:termsandconditions
      t.text      		:features
      t.attachment    :photo

      t.boolean				:publish
      t.datetime			:publish_date
      t.integer				:duration
      t.datetime   		:expiry_date

      t.references 		:deal
      t.integer				:deal_type, default: 0
      t.float					:percent_value, default: 0
      t.float					:amount_value, default: 0
      t.integer				:buy_value, default: 0
      t.integer				:get_value, default: 0
      t.integer				:total_available, default: 0

      t.timestamps null: false
    end

    create_table :end_user_feed_reviews do |t|
      t.integer :end_user_id, null: false
      t.integer :feed_id, null: false
      t.text :message
      t.integer :rating
      
      t.timestamps null: false
    end
    add_index :end_user_feed_reviews, :end_user_id
    add_index :end_user_feed_reviews, :feed_id

    create_table :end_user_feed_favourites do |t|
      t.integer :end_user_id, null: false
      t.integer :feed_id, null: false

      t.timestamps null: false
    end
    add_index :end_user_feed_favourites, :end_user_id
    add_index :end_user_feed_favourites, :feed_id
    add_index :end_user_feed_favourites, [:end_user_id, :feed_id], unique: true
    
    create_table :feed_analytics do |t|
      t.integer :feed_id
      t.integer :user_id
      t.integer :flag

      t.timestamps null: false
    end
    add_index :feed_analytics, :user_id
    add_index :feed_analytics, :feed_id
    add_index :feed_analytics, [:user_id, :feed_id, :flag], unique: true


    create_table :end_user_feed_reminders do |t|
      t.integer :end_user_id, null: false
      t.integer :feed_id, null: false
      t.datetime :reminder_time
      t.boolean  :status, default: true

      t.timestamps null: false
    end
    add_index :end_user_feed_reminders, :end_user_id
    add_index :end_user_feed_reminders, :feed_id
  end
end
