class AddColumnsToUsedDealsAndTrasactionDetails < ActiveRecord::Migration
  def change
    add_column :end_user_used_deals, :transaction_detail_id, :integer
  end
end
