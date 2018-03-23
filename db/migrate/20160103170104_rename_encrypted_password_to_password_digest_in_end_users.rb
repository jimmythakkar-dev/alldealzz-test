class RenameEncryptedPasswordToPasswordDigestInEndUsers < ActiveRecord::Migration
  def up
    rename_column :end_users, :encrypted_password, :password_digest
    add_column :end_users, :facebook_uid, :string
    add_column :end_users, :google_uid, :string
  end

  def down
    remove_column :end_users, :google_uid
    remove_column :end_users, :facebook_uid
    rename_column :end_users, :password_digest, :encrypted_password
  end
end
