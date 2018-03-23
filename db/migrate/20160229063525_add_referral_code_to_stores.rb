class AddReferralCodeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :referral_code, :string
    add_index :stores, :referral_code, :unique => true
  end
end
