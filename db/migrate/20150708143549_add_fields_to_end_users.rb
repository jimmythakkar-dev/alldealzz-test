class AddFieldsToEndUsers < ActiveRecord::Migration
  def up
  	add_column :end_users, :encrypted_password, :string, null: false, default: ""
  	add_column :end_users, :is_profile_update, :boolean, default: false
  	add_column :end_users, :is_categories_set, :boolean, default: false
    remove_column :end_users, :auth_account
  	add_column :end_users, :auth_account, :integer, default: 0
  end

  def down
    change_column :end_users, :auth_account, :string
  	remove_column :end_users, :is_categories_set
  	remove_column :end_users, :is_profile_update
    remove_column :end_users, :encrypted_password
  end
end
