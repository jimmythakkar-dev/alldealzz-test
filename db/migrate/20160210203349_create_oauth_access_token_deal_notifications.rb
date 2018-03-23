class CreateOauthAccessTokenDealNotifications < ActiveRecord::Migration
  def change
    create_table :oauth_access_token_deal_notifications do |t|
      t.integer :oauth_access_token_id, null: false
			t.integer :deal_id, null: false
      t.integer :count, default: 0

      t.timestamps null: false
    end
    add_index :oauth_access_token_deal_notifications, :oauth_access_token_id, name: :index_on_oauth_access_token_id
    add_index :oauth_access_token_deal_notifications, :deal_id, name: :index_on_deal_id
    add_index :oauth_access_token_deal_notifications, [:oauth_access_token_id, :deal_id], unique: true, name: :index_on_oauth_access_token_id_and_deal_id
  end
end
