class AddColumnsToOauthAccessTokens < ActiveRecord::Migration
  def up
    remove_column :end_users, :uid
    remove_column :end_users, :status
    remove_column :end_users, :latitude
    remove_column :end_users, :longitude
    remove_column :end_users, :notification_status
    
    add_column :oauth_access_tokens, :login_type, :integer
    add_column :oauth_access_tokens, :device_type, :boolean
    add_column :oauth_access_tokens, :pn_id, :text
    add_column :oauth_access_tokens, :resource_owner_type, :string
    add_column :oauth_access_tokens, :notification_status, :boolean, default: true
  end

  def down
    add_column :end_users, :uid, :string
    add_column :end_users, :status, :boolean, default: true
    add_column :end_users, :latitude, :numeric
    add_column :end_users, :longitude, :numeric
    add_column :end_users, :notification_status, :boolean, default: true
    
    remove_column :oauth_access_tokens, :login_type
    remove_column :oauth_access_tokens, :device_type
    remove_column :oauth_access_tokens, :pn_id, :text
    remove_column :oauth_access_tokens, :resource_owner_type
    remove_column :oauth_access_tokens, :notification_status
  end
end
