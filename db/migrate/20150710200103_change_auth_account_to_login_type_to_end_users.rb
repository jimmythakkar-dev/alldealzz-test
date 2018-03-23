class ChangeAuthAccountToLoginTypeToEndUsers < ActiveRecord::Migration
  def up
    rename_column :end_users, :auth_account, :login_type
    change_column_default :end_users, :login_type, :null
  end

  def down
    change_column_default :end_users, :login_type, 0
  	rename_column :end_users, :login_type, :auth_account
  end
end
