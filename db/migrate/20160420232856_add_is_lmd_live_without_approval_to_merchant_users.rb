class AddIsLmdLiveWithoutApprovalToMerchantUsers < ActiveRecord::Migration
  def change
    add_column :merchant_users, :is_lmd_live_without_approval, :boolean, default: :false
    add_column :merchant_users, :is_rd_live_without_approval, :boolean, default: :false
    add_column :merchant_users, :is_ed_live_without_approval, :boolean, default: :false
  end
end
