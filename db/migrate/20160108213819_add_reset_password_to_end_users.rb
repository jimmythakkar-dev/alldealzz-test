class AddResetPasswordToEndUsers < ActiveRecord::Migration
  def change
    add_column :end_users, :reset_password_token, :string
    add_column :end_users, :reset_password_sent_at, :datetime
  end
end
