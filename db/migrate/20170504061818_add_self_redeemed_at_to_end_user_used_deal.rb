class AddSelfRedeemedAtToEndUserUsedDeal < ActiveRecord::Migration
  def change
  	add_column :end_user_used_deals, :self_redeemed_at, :datetime
  end
end
