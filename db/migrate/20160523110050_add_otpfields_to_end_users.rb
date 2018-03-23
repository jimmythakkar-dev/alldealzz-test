class AddOtpfieldsToEndUsers < ActiveRecord::Migration
  def change
    add_column :end_users, :otp_code, :string
    add_column :end_users, :otp_verified, :boolean, default: false
    add_column :end_users, :otp_requested, :boolean, default: false
  end
end
